
all: resume.pdf

build:
	@mkdir build

%.pdf: build/%.pdf
	cp $< $@

build/resume.pdf: resume.tex publications.bib | build
	latexmk -interaction=nonstop \
		-f -silent -pdf -lualatex \
		-output-directory=build \
		$<

clean:
	rm -f *.pdf
	rm -rf build
