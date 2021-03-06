CFLAGS := -m64 -std=gnu99 -O2 -g -pthread -D_GNU_SOURCE -Wall
LDFLAGS := -lm
EXEC = lnvm
INSTALL ?= install
DESTDIR =
PREFIX ?= /usr/local
SBINDIR = $(PREFIX)/sbin

# For the uapi header file we priorize this way:
# 1. Use /usr/src/$(uname -r)/include/uapi/linux/lightnvm.h
# 2. Use ./linux/lightnvm.h

ifneq (,$(wildcard /usr/src/linux-headers-$(shell uname -r)/include/uapi/linux/lightnvm.h))
	LIGHTNVM_HEADER = /usr/src/linux-headers-$(shell uname -r)/include/uapi/linux/lightnvm.h
else
	LIGHTNVM_HEADER = ./linux/lightnvm.h
endif

default: $(EXEC)

lnvm: lnvm.c $(LIGHTNVM_HEADER)
	$(CC) $(CFLAGS) lnvm.c $(LDFLAGS) -o $(EXEC)

doc: $(EXEC)
	$(MAKE) -C Documentation

all: lnvm doc

clean:
	rm -f $(EXEC) *.o *~ a.out
	$(MAKE) -C Documentation clean

clobber: clean

install-bin: default
	$(INSTALL) -d $(DESTDIR)$(SBINDIR)
	$(INSTALL) -m 755 lnvm $(DESTDIR)$(SBINDIR)

install: install-bin

.PHONY: default all doc clean clobber install
