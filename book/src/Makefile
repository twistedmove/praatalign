SHELL:=/bin/bash
VERSION:=1.0

all:
	latex -shell-escape book.tex
	latex -shell-escape book.tex
	latex -shell-escape book.tex
	dvipdfm book.dvi
	mv book.pdf book_$(VERSION).pdf

clean:
	rm -vf *.{aux,dvi,log,toc,out}

clobber: clean
	rm -vf *.pdf
