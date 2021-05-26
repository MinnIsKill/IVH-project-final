# Vojtech Kalis (xkalis03)
# Makefile for ITY project 3

# Project number
NUM=3

all: 	proj$(NUM).tex
	latex proj$(NUM).tex
	latex proj$(NUM).tex
	dvips -t a4 proj$(NUM).dvi
	ps2pdf -sPAPERSIZE=a4 proj$(NUM).ps

clean:
	rm -f proj$(NUM).aux proj$(NUM).dvi proj$(NUM).log proj$(NUM).ps