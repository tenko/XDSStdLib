ifeq ($(OS),Windows_NT)
    exe := .exe
else
    exe :=
endif

.PHONY: help
help:
	@echo Commands:
	@echo  -e "lib         		- build optimized library"
	@echo  -e "libdebug    		- build debug version of library"
	@echo  -e "tests       		- build and run library tests"
	@echo  -e "test        		- build and run test.ob2"
	@echo  -e "doc        		- build Sphinx documentation"
	@echo  -e "perfCompare 		- build and run perfCompare"
	@echo  -e "perfCopy    		- build and run perfCopy"
	@echo  -e "perfDictionary   - build and run perfDictionary"
	@echo  -e "perfIndex  		- build and run perfIndex"
	@echo  -e "perfLength  		- build and run perfLength"
	@echo  -e "clean       		- clean intermediate compiler generated files"
	@echo  -e "cleanall    		- clean everything"

.PHONY: lib
lib:
	@xc =p lib -OPTIMIZE_SIZE:- -DEBUG:- -RYU_DEBUG:-

.PHONY: libdebug
libdebug:
	@xc =p lib -DEBUG:+

.PHONY: tests
tests:
	@rm errinfo.* > /dev/null 2>&1 || true
	@xc =p tests/tests && tests/tests$(exe)

.PHONY: test
test:
	@rm errinfo.* > /dev/null 2>&1 || true
	@xc =p tmp/test && tmp/test$(exe)

.PHONY: perfCompare
perfCompare:
	@rm errinfo.* > /dev/null 2>&1 || true
	@xc =p perf/perfCompare && perf/perfCompare$(exe)

.PHONY: perfCopy
perfCopy:
	@rm errinfo.* > /dev/null 2>&1 || true
	@xc =p perf/perfCopy && perf/perfCopy$(exe)

.PHONY: perfDictionary
perfDictionary:
	@rm errinfo.* > /dev/null 2>&1 || true
	@xc =p perf/perfDictionary && perf/perfDictionary$(exe)

.PHONY: perfIndex
perfIndex:
	@rm errinfo.* > /dev/null 2>&1 || true
	@xc =p perf/perfIndex && perf/perfIndex$(exe)

.PHONY: perfLength
perfLength:
	@rm errinfo.* > /dev/null 2>&1 || true
	@xc =p perf/perfLength && perf/perfLength$(exe)

.PHONY: doc
doc:
	@echo Building doc
	@rm -rf build > /dev/null 2>&1 || true
	@-rm -f doc/src/*.rst
	@-mkdir -p doc/src
	@for f in src/*.ob2 ; do ./tools/docgen.py $$f -o doc/$$f.rst ; done
	@echo Creating html
	@make -C doc html
	@start "" build/doc/html/index.html &

.PHONY: clean
clean:
	@echo Cleaning compile generated files
	@rm obj/*.obj > /dev/null 2>&1 || true
	@rm odf/*.odf > /dev/null 2>&1 || true
	@rm sym/*.sym > /dev/null 2>&1 || true
	@rm tmp.lnk > /dev/null 2>&1 || true
	@rm errinfo.* > /dev/null 2>&1 || true

.PHONY: cleanall
cleanall:clean
	@echo Cleaning all
	@rm std.lib > /dev/null 2>&1 || true
	@rm tests/tests$(exe) tests/test$(exe) > /dev/null 2>&1 || true
	@rm perf/perfCompare$(exe) perf/perfLength$(exe) perf/perfCopy$(exe) > /dev/null 2>&1 || true
	@rm doc/src/*.rst > /dev/null 2>&1 || true
	@rm -rf build > /dev/null 2>&1 || true