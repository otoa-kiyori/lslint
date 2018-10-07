PROGRAM = lslint
VERSION_NUMBER = 1.1.1
BUILD_DATE = $(shell date +"%Y-%m-%d")

# See if we're running on mac
UNAME = $(shell uname -a | grep Darwin)
ifneq "$(UNAME)" ""
MAC = 1
endif

LEX = flex
YACC = bison

DEBUG ?= -DDEBUG_LEVEL=LOG_DEBUG_MINOR -ggdb

LINKDEBUG = 
ifneq "$(DEBUG)" ""
LINKDEBUG = -DEBUG
endif

OPTIMIZE ?= 
LDOUTPUT = -o 
UPX = true
CXXOUTPUT = -o

ifdef MAC
CXX = g++ -g -Wall -std=c++98 -pedantic-errors -fno-omit-frame-pointer
LD = g++ -g

else # linux
CXX = g++ -g -Wall -std=c++98 -pedantic-errors -fno-omit-frame-pointer -ffloat-store
LD = g++ -g -static

endif

CXX += $(DEBUG) $(OPTIMIZE) -DVERSION='"$(VERSION)"' -DBUILD_DATE='"$(BUILD_DATE)"'
CC = $(CXX)

ifneq "$(DEBUG)" ""
VERSION = $(VERSION_NUMBER)debug
else
VERSION = $(VERSION_NUMBER)
endif

OBJS = lslmini.tab.o lex.yy.o lslmini.o symtab.o builtins.o builtins_txt.o types.o values.o final_walk.o operators.o logger.o

all: $(PROGRAM)

$(PROGRAM): $(OBJS)
	$(LD) $(LDFLAGS) $(LDOUTPUT)"$@" $^
	$(UPX) "$@"

clean:
	rm -f $(OBJS) lex.yy.c lslint lslmini.tab.c lslmini.tab.h

check: all
	sh test.sh

$(OBJS): lslmini.hh

builtins_txt.cc: builtins.txt
	echo "#ifdef _MSC_VER" > builtins_txt.cc
	echo "#pragma execution_character_set(\"utf-8\")" >> builtins_txt.cc
	echo "#endif" >> builtins_txt.cc
	echo "const char *builtins_txt[] = {" >> builtins_txt.cc
	sed -e '/^\/\//d; s/"/\\\"/g; s/^/"/; s/$$/",/' \
		builtins.txt >> builtins_txt.cc || \
			{ rm -f builtins_txt.cc ; false ; }
	echo "(char*)0 };" >> builtins_txt.cc

lex.yy.o: lex.yy.c lslmini.tab.h

lex.yy.o lslmini.tab.o lslmini.o symtab.o builtins.o: lslmini.hh symtab.hh ast.hh types.hh lslmini.tab.h

logger.o: lslmini.tab.h logger.hh

types.o: types.hh lslmini.hh lslmini.tab.h

values.o final_walk.o operators.o: lslmini.tab.h

lslmini.tab.c lslmini.tab.h: lslmini.y
	$(YACC) -d lslmini.y

lex.yy.c: lslmini.l
	$(LEX) lslmini.l

.c.o .cc.o:
	$(CXX) $(CXXFLAGS) $(CXXOUTPUT)"$@" -c $<

.PHONY: all clean check
