CC				:= /usr/bin/clang
LIB_DIR				:= lib
SRC_DIR				:= src
LIB_OBJ_DIR			:= obj
PREFIX				:= /usr/local

VERSION				:= 0.1
COMPAT_VERSION			:= $(shell echo $(VERSION) | cut -f1 -d.).0

LIB_NAME			:= libgetargv
DYLIB_FILENAME			:= $(LIB_NAME).$(VERSION).dylib
DYLIB				:= $(LIB_DIR)/$(DYLIB_FILENAME)
LIB_OBJ				:= $(LIB_OBJ_DIR)/$(LIB_NAME).o

CPPFLAGS			:= -MMD -MP

.PHONY: install dylib clean
.DEFAULT_GOAL:= $(DYLIB)

$(DYLIB): $(LIB_OBJ) | $(LIB_DIR)
	$(CC) $(LDFLAGS) -dynamiclib -current_version $(VERSION) -compatibility_version $(COMPAT_VERSION) $< -o $@

install: $(DYLIB)
	install -d $(PREFIX)/$(LIB_DIR)
	install $(DYLIB) $(PREFIX)/$(DYLIB)
	install_name_tool -id $(PREFIX)/$(DYLIB) $(PREFIX)/$(DYLIB)
	ln -sf ./$(DYLIB_FILENAME:%.$(VERSION).dylib=%.$(COMPAT_VERSION:%.0=%).dylib) $(PREFIX)/$(DYLIB:%.$(VERSION).dylib=%.dylib)
	ln -sf ./$(DYLIB_FILENAME) $(PREFIX)/$(DYLIB:%.$(VERSION).dylib=%.$(COMPAT_VERSION:%.0=%).dylib)
	install -d $(PREFIX)/include
	install -m 444 $(wildcard include/*.h) $(PREFIX)/include/
	install -d $(PREFIX)/$(LIB_DIR)/pkgconfig/
	install -m 444 getargv.pc $(PREFIX)/$(LIB_DIR)/pkgconfig/

$(LIB_DIR) $(LIB_OBJ_DIR):
	mkdir -p $@

clean:
	@$(RM) -rv $(LIB_DIR) $(LIB_OBJ_DIR)

$(LIB_OBJ_DIR)/lib%.o: $(SRC_DIR)/%.c | $(LIB_OBJ_DIR)
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

-include $(LIB_OBJ:.o=.d)
