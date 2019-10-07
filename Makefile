.DEFAULT_GOAL := usage
.PHONY: chicken

usage:
	@ echo "make all # create distributions for all installed lisps"

lispworks:
	@ mkdir -p dist/lispworks
	@ cd src && lispworks -build deliver.lisp

ecl:
	@ mkdir -p dist/ecl
	@ cat src/deliver-ecl.lisp|ecl

sbcl:
	@ mkdir -p dist/sbcl
	@ cd src && cat deliver.lisp|sbcl --control-stack-size 2048 --dynamic-space-size 20480  2>&1 > /dev/null #--control-stack-size 2048  #--disable-debugger
ccl:
	@ mkdir -p dist/ccl || true
	@ cd src && cat deliver.lisp|ccl64

clisp:
	@ mkdir -p dist/clisp || true
	@ cd src && cat deliver.lisp|clisp

allegro:
	@ rm -rf dist/allegro scrypt
	@ mkdir -p dist/allegro
	@ cd src && cat deliver.lisp|allegro
	@ mv src/scrypt/* dist/allegro
	@ rm -rf src/scrypt

abcl:
	@ mkdir -p dist/abcl || true
	@ cat deliver.lisp|abcl

cmucl:
	@ cat deliver.lisp|/usr/cmucl/bin/lisp

bench: all
	rm -rf /tmp/m-a && mkdir /tmp/m-a
	METIS="/tmp/m-a/" time metis-sbcl s ~/ct-test > results/sbcl 2>&1
	rm -rf /tmp/m-a && mkdir /tmp/m-a
	METIS="/tmp/m-a/" time metis-lispworks s ~/ct-test > results/lispworks 2>&1
	rm -rf /tmp/m-a && mkdir /tmp/m-a
	METIS="/tmp/m-a/" time metis-allegro s ~/ct-test > results/allegro  2>&1
	rm -rf /tmp/m-a && mkdir /tmp/m-a
	METIS="/tmp/m-a/" time metis-ccl s ~/ct-test > results/ccl 2>&1
	rm -rf /tmp/m-a
	git add results && git commit -a -m "benchmark results" && git push

all: lispworks sbcl ccl allegro
