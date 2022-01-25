
all: resume.pdf

build:
	@mkdir build

resume.pdf: resume.tex publications.bib | build
	@echo "\033[0;94m[PDFLATEX]\033[0m $@"
	@pdflatex -interaction=nonstopmode -output-directory=build $< >build/log.txt 2>&1 || ( cat build/log.txt >&2; exit 1 )
	@echo "\033[0;94m[BIBER]\033[0m $@"
	@biber build/resume.bcf
	@echo "\033[0;94m[PDFLATEX]\033[0m $@"
	@pdflatex -interaction=nonstopmode -output-directory=build $< >build/log.txt 2>&1 || ( cat build/log.txt >&2; exit 1 )
	@echo "\033[0;94m[PDFLATEX]\033[0m $@"
	@pdflatex -interaction=nonstopmode -output-directory=build $< >build/log.txt 2>&1 || ( cat build/log.txt >&2; exit 1 )
	@mv build/`basename $@` $@

clean:
	rm -f *.pdf
	rm -rf build
