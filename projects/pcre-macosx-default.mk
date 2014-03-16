#
#   pcre-macosx-default.mk -- Makefile to build PCRE Library for macosx
#

NAME                  := pcre
VERSION               := 1.0.3
PROFILE               ?= default
ARCH                  ?= $(shell uname -m | sed 's/i.86/x86/;s/x86_64/x64/;s/arm.*/arm/;s/mips.*/mips/')
CC_ARCH               ?= $(shell echo $(ARCH) | sed 's/x86/i686/;s/x64/x86_64/')
OS                    ?= macosx
CC                    ?= clang
LD                    ?= link
CONFIG                ?= $(OS)-$(ARCH)-$(PROFILE)
LBIN                  ?= $(CONFIG)/bin
PATH                  := $(LBIN):$(PATH)


ME_EXT_COMPILER_PATH  ?= clang
ME_EXT_LIB_PATH       ?= ar
ME_EXT_LINK_PATH      ?= link
ME_EXT_VXWORKS_PATH   ?= $(WIND_BASE)
ME_EXT_WINSDK_PATH    ?= winsdk

export WIND_HOME      ?= $(WIND_BASE)/..

CFLAGS                += -w
DFLAGS                +=  $(patsubst %,-D%,$(filter ME_%,$(MAKEFLAGS))) 
IFLAGS                += "-I$(CONFIG)/inc"
LDFLAGS               += '-Wl,-rpath,@executable_path/' '-Wl,-rpath,@loader_path/'
LIBPATHS              += -L$(CONFIG)/bin
LIBS                  += -ldl -lpthread -lm

DEBUG                 ?= debug
CFLAGS-debug          ?= -g
DFLAGS-debug          ?= -DME_DEBUG
LDFLAGS-debug         ?= -g
DFLAGS-release        ?= 
CFLAGS-release        ?= -O2
LDFLAGS-release       ?= 
CFLAGS                += $(CFLAGS-$(DEBUG))
DFLAGS                += $(DFLAGS-$(DEBUG))
LDFLAGS               += $(LDFLAGS-$(DEBUG))

ME_ROOT_PREFIX        ?= 
ME_BASE_PREFIX        ?= $(ME_ROOT_PREFIX)/usr/local
ME_DATA_PREFIX        ?= $(ME_ROOT_PREFIX)/
ME_STATE_PREFIX       ?= $(ME_ROOT_PREFIX)/var
ME_APP_PREFIX         ?= $(ME_BASE_PREFIX)/lib/$(NAME)
ME_VAPP_PREFIX        ?= $(ME_APP_PREFIX)/$(VERSION)
ME_BIN_PREFIX         ?= $(ME_ROOT_PREFIX)/usr/local/bin
ME_INC_PREFIX         ?= $(ME_ROOT_PREFIX)/usr/local/include
ME_LIB_PREFIX         ?= $(ME_ROOT_PREFIX)/usr/local/lib
ME_MAN_PREFIX         ?= $(ME_ROOT_PREFIX)/usr/local/share/man
ME_SBIN_PREFIX        ?= $(ME_ROOT_PREFIX)/usr/local/sbin
ME_ETC_PREFIX         ?= $(ME_ROOT_PREFIX)/etc/$(NAME)
ME_WEB_PREFIX         ?= $(ME_ROOT_PREFIX)/var/www/$(NAME)-default
ME_LOG_PREFIX         ?= $(ME_ROOT_PREFIX)/var/log/$(NAME)
ME_SPOOL_PREFIX       ?= $(ME_ROOT_PREFIX)/var/spool/$(NAME)
ME_CACHE_PREFIX       ?= $(ME_ROOT_PREFIX)/var/spool/$(NAME)/cache
ME_SRC_PREFIX         ?= $(ME_ROOT_PREFIX)$(NAME)-$(VERSION)


TARGETS               += $(CONFIG)/bin/libpcre.dylib

unexport CDPATH

ifndef SHOW
.SILENT:
endif

all build compile: prep $(TARGETS)

.PHONY: prep

prep:
	@echo "      [Info] Use "make SHOW=1" to trace executed commands."
	@if [ "$(CONFIG)" = "" ] ; then echo WARNING: CONFIG not set ; exit 255 ; fi
	@if [ "$(ME_APP_PREFIX)" = "" ] ; then echo WARNING: ME_APP_PREFIX not set ; exit 255 ; fi
	@[ ! -x $(CONFIG)/bin ] && mkdir -p $(CONFIG)/bin; true
	@[ ! -x $(CONFIG)/inc ] && mkdir -p $(CONFIG)/inc; true
	@[ ! -x $(CONFIG)/obj ] && mkdir -p $(CONFIG)/obj; true
	@[ ! -f $(CONFIG)/inc/me.h ] && cp projects/pcre-macosx-default-me.h $(CONFIG)/inc/me.h ; true
	@if ! diff $(CONFIG)/inc/me.h projects/pcre-macosx-default-me.h >/dev/null ; then\
		cp projects/pcre-macosx-default-me.h $(CONFIG)/inc/me.h  ; \
	fi; true
	@if [ -f "$(CONFIG)/.makeflags" ] ; then \
		if [ "$(MAKEFLAGS)" != " ` cat $(CONFIG)/.makeflags`" ] ; then \
			echo "   [Warning] Make flags have changed since the last build: "`cat $(CONFIG)/.makeflags`"" ; \
		fi ; \
	fi
	@echo $(MAKEFLAGS) >$(CONFIG)/.makeflags

clean:
	rm -f "$(CONFIG)/bin/libpcre.dylib"
	rm -f "$(CONFIG)/obj/pcre_chartables.o"
	rm -f "$(CONFIG)/obj/pcre_compile.o"
	rm -f "$(CONFIG)/obj/pcre_exec.o"
	rm -f "$(CONFIG)/obj/pcre_globals.o"
	rm -f "$(CONFIG)/obj/pcre_newline.o"
	rm -f "$(CONFIG)/obj/pcre_ord2utf8.o"
	rm -f "$(CONFIG)/obj/pcre_tables.o"
	rm -f "$(CONFIG)/obj/pcre_try_flipped.o"
	rm -f "$(CONFIG)/obj/pcre_ucp_searchfuncs.o"
	rm -f "$(CONFIG)/obj/pcre_valid_utf8.o"
	rm -f "$(CONFIG)/obj/pcre_xclass.o"

clobber: clean
	rm -fr ./$(CONFIG)



#
#   version
#
version: $(DEPS_1)
	echo 1.0.3

#
#   config.h
#
$(CONFIG)/inc/config.h: $(DEPS_2)
	@echo '      [Copy] $(CONFIG)/inc/config.h'
	mkdir -p "$(CONFIG)/inc"
	cp src/config.h $(CONFIG)/inc/config.h

#
#   pcre.h
#
$(CONFIG)/inc/pcre.h: $(DEPS_3)
	@echo '      [Copy] $(CONFIG)/inc/pcre.h'
	mkdir -p "$(CONFIG)/inc"
	cp src/pcre.h $(CONFIG)/inc/pcre.h

#
#   pcre_internal.h
#
$(CONFIG)/inc/pcre_internal.h: $(DEPS_4)
	@echo '      [Copy] $(CONFIG)/inc/pcre_internal.h'
	mkdir -p "$(CONFIG)/inc"
	cp src/pcre_internal.h $(CONFIG)/inc/pcre_internal.h

#
#   me.h
#
$(CONFIG)/inc/me.h: $(DEPS_5)
	@echo '      [Copy] $(CONFIG)/inc/me.h'

#
#   ucp.h
#
DEPS_6 += $(CONFIG)/inc/me.h

$(CONFIG)/inc/ucp.h: $(DEPS_6)
	@echo '      [Copy] $(CONFIG)/inc/ucp.h'
	mkdir -p "$(CONFIG)/inc"
	cp src/ucp.h $(CONFIG)/inc/ucp.h

#
#   ucpinternal.h
#
$(CONFIG)/inc/ucpinternal.h: $(DEPS_7)
	@echo '      [Copy] $(CONFIG)/inc/ucpinternal.h'
	mkdir -p "$(CONFIG)/inc"
	cp src/ucpinternal.h $(CONFIG)/inc/ucpinternal.h

#
#   ucptable.h
#
$(CONFIG)/inc/ucptable.h: $(DEPS_8)
	@echo '      [Copy] $(CONFIG)/inc/ucptable.h'
	mkdir -p "$(CONFIG)/inc"
	cp src/ucptable.h $(CONFIG)/inc/ucptable.h

#
#   pcre_chartables.o
#
DEPS_9 += $(CONFIG)/inc/me.h
DEPS_9 += $(CONFIG)/inc/config.h
DEPS_9 += $(CONFIG)/inc/pcre_internal.h
DEPS_9 += $(CONFIG)/inc/pcre.h
DEPS_9 += $(CONFIG)/inc/ucp.h

$(CONFIG)/obj/pcre_chartables.o: \
    src/pcre_chartables.c $(DEPS_9)
	@echo '   [Compile] $(CONFIG)/obj/pcre_chartables.o'
	$(CC) -c $(CFLAGS) $(DFLAGS) -o $(CONFIG)/obj/pcre_chartables.o -arch $(CC_ARCH) $(IFLAGS) src/pcre_chartables.c

#
#   pcre_compile.o
#
DEPS_10 += $(CONFIG)/inc/me.h
DEPS_10 += $(CONFIG)/inc/config.h
DEPS_10 += $(CONFIG)/inc/pcre_internal.h

$(CONFIG)/obj/pcre_compile.o: \
    src/pcre_compile.c $(DEPS_10)
	@echo '   [Compile] $(CONFIG)/obj/pcre_compile.o'
	$(CC) -c $(CFLAGS) $(DFLAGS) -o $(CONFIG)/obj/pcre_compile.o -arch $(CC_ARCH) $(IFLAGS) src/pcre_compile.c

#
#   pcre_exec.o
#
DEPS_11 += $(CONFIG)/inc/me.h
DEPS_11 += $(CONFIG)/inc/config.h
DEPS_11 += $(CONFIG)/inc/pcre_internal.h

$(CONFIG)/obj/pcre_exec.o: \
    src/pcre_exec.c $(DEPS_11)
	@echo '   [Compile] $(CONFIG)/obj/pcre_exec.o'
	$(CC) -c $(CFLAGS) $(DFLAGS) -o $(CONFIG)/obj/pcre_exec.o -arch $(CC_ARCH) $(IFLAGS) src/pcre_exec.c

#
#   pcre_globals.o
#
DEPS_12 += $(CONFIG)/inc/me.h
DEPS_12 += $(CONFIG)/inc/config.h
DEPS_12 += $(CONFIG)/inc/pcre_internal.h

$(CONFIG)/obj/pcre_globals.o: \
    src/pcre_globals.c $(DEPS_12)
	@echo '   [Compile] $(CONFIG)/obj/pcre_globals.o'
	$(CC) -c $(CFLAGS) $(DFLAGS) -o $(CONFIG)/obj/pcre_globals.o -arch $(CC_ARCH) $(IFLAGS) src/pcre_globals.c

#
#   pcre_newline.o
#
DEPS_13 += $(CONFIG)/inc/me.h
DEPS_13 += $(CONFIG)/inc/config.h
DEPS_13 += $(CONFIG)/inc/pcre_internal.h

$(CONFIG)/obj/pcre_newline.o: \
    src/pcre_newline.c $(DEPS_13)
	@echo '   [Compile] $(CONFIG)/obj/pcre_newline.o'
	$(CC) -c $(CFLAGS) $(DFLAGS) -o $(CONFIG)/obj/pcre_newline.o -arch $(CC_ARCH) $(IFLAGS) src/pcre_newline.c

#
#   pcre_ord2utf8.o
#
DEPS_14 += $(CONFIG)/inc/me.h
DEPS_14 += $(CONFIG)/inc/config.h
DEPS_14 += $(CONFIG)/inc/pcre_internal.h

$(CONFIG)/obj/pcre_ord2utf8.o: \
    src/pcre_ord2utf8.c $(DEPS_14)
	@echo '   [Compile] $(CONFIG)/obj/pcre_ord2utf8.o'
	$(CC) -c $(CFLAGS) $(DFLAGS) -o $(CONFIG)/obj/pcre_ord2utf8.o -arch $(CC_ARCH) $(IFLAGS) src/pcre_ord2utf8.c

#
#   pcre_tables.o
#
DEPS_15 += $(CONFIG)/inc/me.h
DEPS_15 += $(CONFIG)/inc/config.h
DEPS_15 += $(CONFIG)/inc/pcre_internal.h

$(CONFIG)/obj/pcre_tables.o: \
    src/pcre_tables.c $(DEPS_15)
	@echo '   [Compile] $(CONFIG)/obj/pcre_tables.o'
	$(CC) -c $(CFLAGS) $(DFLAGS) -o $(CONFIG)/obj/pcre_tables.o -arch $(CC_ARCH) $(IFLAGS) src/pcre_tables.c

#
#   pcre_try_flipped.o
#
DEPS_16 += $(CONFIG)/inc/me.h
DEPS_16 += $(CONFIG)/inc/config.h
DEPS_16 += $(CONFIG)/inc/pcre_internal.h

$(CONFIG)/obj/pcre_try_flipped.o: \
    src/pcre_try_flipped.c $(DEPS_16)
	@echo '   [Compile] $(CONFIG)/obj/pcre_try_flipped.o'
	$(CC) -c $(CFLAGS) $(DFLAGS) -o $(CONFIG)/obj/pcre_try_flipped.o -arch $(CC_ARCH) $(IFLAGS) src/pcre_try_flipped.c

#
#   pcre_ucp_searchfuncs.o
#
DEPS_17 += $(CONFIG)/inc/me.h
DEPS_17 += $(CONFIG)/inc/config.h
DEPS_17 += $(CONFIG)/inc/pcre_internal.h

$(CONFIG)/obj/pcre_ucp_searchfuncs.o: \
    src/pcre_ucp_searchfuncs.c $(DEPS_17)
	@echo '   [Compile] $(CONFIG)/obj/pcre_ucp_searchfuncs.o'
	$(CC) -c $(CFLAGS) $(DFLAGS) -o $(CONFIG)/obj/pcre_ucp_searchfuncs.o -arch $(CC_ARCH) $(IFLAGS) src/pcre_ucp_searchfuncs.c

#
#   pcre_valid_utf8.o
#
DEPS_18 += $(CONFIG)/inc/me.h
DEPS_18 += $(CONFIG)/inc/config.h
DEPS_18 += $(CONFIG)/inc/pcre_internal.h

$(CONFIG)/obj/pcre_valid_utf8.o: \
    src/pcre_valid_utf8.c $(DEPS_18)
	@echo '   [Compile] $(CONFIG)/obj/pcre_valid_utf8.o'
	$(CC) -c $(CFLAGS) $(DFLAGS) -o $(CONFIG)/obj/pcre_valid_utf8.o -arch $(CC_ARCH) $(IFLAGS) src/pcre_valid_utf8.c

#
#   pcre_xclass.o
#
DEPS_19 += $(CONFIG)/inc/me.h
DEPS_19 += $(CONFIG)/inc/config.h
DEPS_19 += $(CONFIG)/inc/pcre_internal.h

$(CONFIG)/obj/pcre_xclass.o: \
    src/pcre_xclass.c $(DEPS_19)
	@echo '   [Compile] $(CONFIG)/obj/pcre_xclass.o'
	$(CC) -c $(CFLAGS) $(DFLAGS) -o $(CONFIG)/obj/pcre_xclass.o -arch $(CC_ARCH) $(IFLAGS) src/pcre_xclass.c

#
#   libpcre
#
DEPS_20 += $(CONFIG)/inc/config.h
DEPS_20 += $(CONFIG)/inc/pcre.h
DEPS_20 += $(CONFIG)/inc/pcre_internal.h
DEPS_20 += $(CONFIG)/inc/me.h
DEPS_20 += $(CONFIG)/inc/ucp.h
DEPS_20 += $(CONFIG)/inc/ucpinternal.h
DEPS_20 += $(CONFIG)/inc/ucptable.h
DEPS_20 += $(CONFIG)/obj/pcre_chartables.o
DEPS_20 += $(CONFIG)/obj/pcre_compile.o
DEPS_20 += $(CONFIG)/obj/pcre_exec.o
DEPS_20 += $(CONFIG)/obj/pcre_globals.o
DEPS_20 += $(CONFIG)/obj/pcre_newline.o
DEPS_20 += $(CONFIG)/obj/pcre_ord2utf8.o
DEPS_20 += $(CONFIG)/obj/pcre_tables.o
DEPS_20 += $(CONFIG)/obj/pcre_try_flipped.o
DEPS_20 += $(CONFIG)/obj/pcre_ucp_searchfuncs.o
DEPS_20 += $(CONFIG)/obj/pcre_valid_utf8.o
DEPS_20 += $(CONFIG)/obj/pcre_xclass.o

$(CONFIG)/bin/libpcre.dylib: $(DEPS_20)
	@echo '      [Link] $(CONFIG)/bin/libpcre.dylib'
	$(CC) -dynamiclib -o $(CONFIG)/bin/libpcre.dylib -arch $(CC_ARCH) $(LDFLAGS) $(LIBPATHS) -install_name @rpath/libpcre.dylib -compatibility_version 1.0.3 -current_version 1.0.3 "$(CONFIG)/obj/pcre_chartables.o" "$(CONFIG)/obj/pcre_compile.o" "$(CONFIG)/obj/pcre_exec.o" "$(CONFIG)/obj/pcre_globals.o" "$(CONFIG)/obj/pcre_newline.o" "$(CONFIG)/obj/pcre_ord2utf8.o" "$(CONFIG)/obj/pcre_tables.o" "$(CONFIG)/obj/pcre_try_flipped.o" "$(CONFIG)/obj/pcre_ucp_searchfuncs.o" "$(CONFIG)/obj/pcre_valid_utf8.o" "$(CONFIG)/obj/pcre_xclass.o" $(LIBS) 

#
#   stop
#
stop: $(DEPS_21)

#
#   installBinary
#
installBinary: $(DEPS_22)

#
#   start
#
start: $(DEPS_23)

#
#   install
#
DEPS_24 += stop
DEPS_24 += installBinary
DEPS_24 += start

install: $(DEPS_24)

#
#   uninstall
#
DEPS_25 += stop

uninstall: $(DEPS_25)

