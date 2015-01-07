SHELL:=/bin/bash
VERSION:=1.0

all:
	latex -shell-escape book.tex
	latex -shell-escape book.tex
	latex -shell-escape book.tex
	dvipdfm book.dvi
	mv book.pdf

release: clobber
	zip -9rv book_$(VERSION).zip *
	tar -cvf book_$(VERSION).tar *
	gzip -vv9c book_$(VERSION).tar > book_$(VERSION).tar.gz
	bzip2 -vv9c book_$(VERSION).tar > book_$(VERSION).tar.bz2
	xz -vvec book_$(VERSION).tar > book_$(VERSION).tar.xz
	rm book_$(VERSION).tar
	mv book_$(VERSION)* ../

clean:
	rm -vf *.{aux,dvi,log,toc,out}

clobber: clean
	rm -vf *.pdf
