CC				:= /usr/bin/clang
LIB_OBJ_DIR			:= obj
PREFIX				:= /usr/local

VERSION				:= 0.1
COMPAT_VERSION			:= $(shell echo $(VERSION) | cut -f1 -d.).0

LIB_NAME			:= libgetargv
EXTENSION			:= dylib
DYLIB_FILENAME			:= $(LIB_NAME).$(VERSION).$(EXTENSION)
DYLIB				:= lib/$(DYLIB_FILENAME)
LIB_OBJ				:= $(LIB_OBJ_DIR)/$(LIB_NAME).o

CPPFLAGS			:= -MMD -MP

.PHONY: install dylib clean
.DEFAULT_GOAL:= $(DYLIB)

$(DYLIB): $(LIB_OBJ) | lib
	$(CC) $(LDFLAGS) -dynamiclib -current_version $(VERSION) -compatibility_version $(COMPAT_VERSION) $< -o $@

install: $(DYLIB)
	install -d $(PREFIX)/lib
	install $(DYLIB) $(PREFIX)/$(DYLIB)
	install_name_tool -id $(PREFIX)/$(DYLIB) $(PREFIX)/$(DYLIB)
	ln -sf ./$(DYLIB_FILENAME:%.$(VERSION).$(EXTENSION)=%.$(COMPAT_VERSION:%.0=%).$(EXTENSION)) $(PREFIX)/$(DYLIB:%.$(VERSION).$(EXTENSION)=%.$(EXTENSION))
	ln -sf ./$(DYLIB_FILENAME) $(PREFIX)/$(DYLIB:%.$(VERSION).$(EXTENSION)=%.$(COMPAT_VERSION:%.0=%).$(EXTENSION))
	install -d $(PREFIX)/include
	install -m 444 $(wildcard include/*.h) $(PREFIX)/include/
	install -d $(PREFIX)/lib/pkgconfig/
	install -m 444 getargv.pc $(PREFIX)/lib/pkgconfig/
	./sed -e 's|prefix=.*|prefix=$(PREFIX)|' -i '' $(PREFIX)/lib/pkgconfig/getargv.pc

lib $(LIB_OBJ_DIR):
	mkdir -p $@

clean:
	@$(RM) -rv lib $(LIB_OBJ_DIR)

$(LIB_OBJ_DIR)/lib%.o: src/%.c | $(LIB_OBJ_DIR)
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

-include $(LIB_OBJ:.o=.d)
