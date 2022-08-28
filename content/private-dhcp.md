---
title: Private DHCP
date: 2014-05-17
tags: [networking, dhcp, hans]
---

Recently I was working on a project in which I was creating loads of tap
devices, with [HaNS](https://github.com/galoisinc/hans) instances connected to
them.  Initially, I was abusing the Galois network, stealing away precious
addresses from our internal /24 allocation.  This wasn't the end of the world,
as I was reusing addresses I was given, but it got me thinking: shouldn't I
be able to just allocate my own addresses?

<!--more-->

After a bit of googling, I decided to use
[Dnsmasq](http://www.thekelleys.org.uk/dnsmasq/doc.html) to manage DNS caching,
and DHCP.  My first step was then to configure the network.

Network Configuration
---------------------
`NetworkManager` injects a bit too much uncertainty into the network
configuration, so I opted to disable it, and configure the network manually.

```
$ sudo systemctl stop NetworkManager
$ sudo systemctl disable NetworkManager
```

I'll be configuring all devices using the config scripts stored in
`/etc/sysconfig/network-scripts`, which requires enabling the `network` service.
I'm not going to enable it here, but instead just restart the machine later.  I
know that I should be able to just start it after my configuration is done, but
I was experiencing some odd crashes when following that workflow that
disappeared with a reboot.

```shell
$ sudo systemctl enable network
```

Make sure that the ethernet device you're planning on using as your interface to
the rest of the world is configured to your liking.  I'm doing DHCP with mine to
get configuration data from the outer network, so it looks like the following.
(To make work easier, I'm putting everything in the trusted firewall zone --
this is a development VM, so I don't feel too bad.)

 * `/etc/sysconfig/network-scripts/ifcfg-p2p1`

```shell
DEVICE="p2p1"
ONBOOT=yes
BOOTPROTO="dhcp"
HWADDR="08:00:27:59:00:f8"
TYPE=Ethernet
NAME="p2p1"
ZONE="trusted"
```

Additionally, I've created a bridge named `br0` and a dummy device to occupy it,
named `dummy0`:

* `/etc/sysconfig/network-scripts/ifcfg-br0`
  ```shell
  DEVICE="br0"
  ONBOOT=yes
  BOOTPROTO=static
  TYPE=Bridge
  NAME="br0"
  ZONE="trusted"
  IPADDR=10.37.0.1
  NETMASK=255.255.255.0
  ```

* `/etc/sysconfig/network-scripts/ifcfg-dummy0`
  ```shell
  DEVNAME=dummy0
  ONBOOT=yes
  BOOTPROTO=none
  TYPE=Ethernet
  NAME=dummy0
  ZONE=trusted
  BRIDGE=br0
  ```

At this point, the layout of the network is all set.  Now, I just need to make
sure that the `dummy` kernel module will load at startup, and that I'll be able
to forward traffic between `br0` and `p2p1`.  Loading the module is fairly
straightforward, as I can just dump the following listing into
`/etc/sysconfig/modules/dummy.modules`

```shell
#!/bin/sh

modprobe -a dummy
```

Next, let's make sure that packets will be forwarded between `p2p1` and `br0` by
setting the `net.ipv4.ip_forward` sysctl in /etc/sysctl.conf.

```shell
net.ipv4.ip_forward = 1
```

Finally, we're ready to reboot, and then begin setting up `Dnamasq`.

```shell
$ sudo reboot
```

Dnsmasq
-------

First, let's install the server.

```shell
$ sudo yum install dnsmasq
```

Now, let's make minimal modifications to `/etc/dnsmasq.conf`, enabling the
`domain-needed` and `bogus-priv` options to make us better netizens.  The
effective full `dnsmasq.conf` file is included below.

```shell
domain-needed
bogus-priv
conf-dir=/etc/dnsmasq.d
```

Now we'll configure the DHCP server in `/etc/dnsmasq.d/dhcp.conf`:

```shell
listen-address=10.37.0.1
dhcp-range=10.37.0.2,10.37.0.254,12h
```

This gives us most of a /24 network to work with, and listens on the address we
gave to the bridge in `/etc/sysconfig/network-scripts/ifcfg-br0`.

At this point, dnsmasq can be started, and we can test that everything is
working by using the `tcp-test` program from
[HaNS](https://github.com/galoisinc/hans).

* Enable `Dnsmasq`
  ```shell
  $ sudo systemctl enable dnsmasq
  $ sudo systemctl start dnsmasq
  ```

* Create a tap device for `tcp-test` to use, and add it to the brige that
  `Dnsmasq` is listening on
  ```shell
  $ owner=$USER
  $ sudo tunctl -p -u $owner -t tap6
  $ sudo brctl addif br0 tap0
  $ sudo ip link set tap0 up
  ```

* Start `tcp-test` (assuming that you've already built it with `cabal build`,
  and are in the base of the [HaNS](https://github.com/galoisinc/hans) repo)
  ```shell
  $ ./dist/build/tcp-test/tcp-test dhcp
  Network stack running...
  Discovering address
  Bound to address: 10.37.0.89
  accepting
  ...
  ```

From a separate terminal you should be able to ping the address that `tcp-test`
outputted, `10.37.0.89` in this case`, and see fairly quick responses.


External Access
---------------

In order to have access to this new network node, from a host outside of the
machine that it's running on, you'll need to install a route to the
`10.37.0.0/24` network.  You'll need to know the address of your ethernet device
(`p2p1` here) to install this route.

```shell
$ ip addr show dev p2p1
```

In my case, this was the address `10.0.1.5`.  Next, install the host-specific
route.  (Remember to replace `10.0.1.5` with the address you're using.)

* Mac OSX
  ```shell
  $ sudo route -n 10.37.0.0/24 10.0.1.5
  ```

* Linux
  ```shell
  $ sudo ip route add 10.37.0.0/24 via 10.0.1.5
  ```

Conclusion
----------

Hooray!  Now you can manage all of the devices that are added to the bridge
`br0` with a real DHCP server, making the propegation of configuration data a
breeze.
