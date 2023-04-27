CC				:= /usr/bin/clang
LIB_DIR				:= lib
SRC_DIR				:= src
LIB_OBJ_DIR			:= lib_obj
PREFIX				:= /usr/local

MACOS_VER_NUM			:= $(shell bash -c 'cat <(sw_vers -productVersion) <(xcrun --show-sdk-version) | sort -V | head -1')
MACOS_VER_MAJOR			:= $(shell echo $(MACOS_VER_NUM) | cut -f1 -d.)
MACOS_VER_MINOR			:= $(shell echo $(MACOS_VER_NUM) | cut -f2 -d.)
export MACOSX_DEPLOYMENT_TARGET := $(MACOS_VER_MAJOR).$(MACOS_VER_MINOR)
ARCH				:= $(shell uname -m)
PAGE_SIZE			:= $(shell printf '%x\n' $(shell sysctl -n hw.pagesize))

VERSION				:= 0.1
COMPAT_VERSION			:= $(shell echo $(VERSION) | cut -f1 -d.).0

LIB_NAME			:= libgetargv
DYLIB_FILENAME			:= $(LIB_NAME).$(VERSION).dylib
DYLIB				:= $(LIB_DIR)/$(DYLIB_FILENAME)
LIB_OBJ				:= $(LIB_OBJ_DIR)/$(LIB_NAME).o

CPPFLAGS			:= -MMD -MP -D_FORTIFY_SOURCE=2 -fvisibility=hidden
CFLAGS				:= -g -Os -fPIE -fPIC -fstack-protector -finline-functions -fno-unwind-tables -fno-asynchronous-unwind-tables -fno-exceptions -fstack-protector-strong -march=native -mtune=native -pedantic-errors
LDFLAGS				:= -fstack-clash-protection -Wl,-dead_strip,-segalign,$(PAGE_SIZE),-object_path_lto,obj/lto.o,-e,_getargv -flto

.PHONY: install dylib clean
.DEFAULT_GOAL:= $(DYLIB)

$(DYLIB): $(LIB_OBJ) | $(LIB_DIR) $(LIB_OBJ_DIR)
	$(CC) $(LDFLAGS) -dynamiclib -current_version $(VERSION) -compatibility_version $(COMPAT_VERSION) -Wl,-headerpad_max_install_names,-install_name,@executable_path/../$@ $< -o $@

install: $(DYLIB)
	install -d $(PREFIX)/$(LIB_DIR)
	install $(DYLIB) $(PREFIX)/$(DYLIB)
	install_name_tool -id $(PREFIX)/$(DYLIB) $(PREFIX)/$(DYLIB)
	ln -sf ./$(DYLIB_FILENAME:%.$(VERSION).dylib=%.$(COMPAT_VERSION:%.0=%).dylib) $(PREFIX)/$(DYLIB:%.$(VERSION).dylib=%.dylib)
	ln -sf ./$(DYLIB_FILENAME) $(PREFIX)/$(DYLIB:%.$(VERSION).dylib=%.$(COMPAT_VERSION:%.0=%).dylib)
	install -d $(PREFIX)/include
	install -m 444 $(wildcard include/*.h) $(PREFIX)/include/

$(LIB_DIR) $(LIB_OBJ_DIR):
	mkdir -p $@

clean:
	@$(RM) -rv $(LIB_DIR) $(LIB_OBJ_DIR)

$(LIB_OBJ_DIR)/lib%.o: $(SRC_DIR)/%.c | $(LIB_OBJ_DIR)
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

-include $(LIB_OBJ:.o=.d)
