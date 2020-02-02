# yaxwm - yet another x window manager

include config.mk

# debug build (make -DDEBUG ...)
ifneq ($(findstring DEBUG,$(DFLAGS)),)
	LDFLAGS += -lxkbcommon
endif
# no strip build (make -DNOSTRIP ...)
ifneq ($(findstring NOSTRIP,$(DFLAGS)),)
	CFLAGS += -g
endif

CFLAGS += -DVERSION=\"${VERSION}\" ${DFLAGS}

all: options yaxwm

options:
	@echo yaxwm build options:
	@echo "CC       = ${CC}"
	@echo "CFLAGS   = ${CFLAGS}"
	@echo "LDFLAGS  = ${LDFLAGS}"

config.h:
	cp config.def.h $@

yaxwm: config.h
	${CC} yaxwm.c -o $@ ${CFLAGS}\
		${LDFLAGS}

clean:
	rm -f yaxwm

install: all
	mkdir -p ${DESTDIR}${PREFIX}/bin
	cp -f yaxwm ${DESTDIR}${PREFIX}/bin
	chmod 755 ${DESTDIR}${PREFIX}/bin/yaxwm
	mkdir -p ${DESTDIR}${MANPREFIX}/man1
	sed "s/VERSION/${VERSION}/g" yaxwm.1 > ${DESTDIR}${MANPREFIX}/man1/yaxwm.1
	chmod 644 ${DESTDIR}${MANPREFIX}/man1/yaxwm.1

uninstall:
	rm -f ${DESTDIR}${PREFIX}/bin/yaxwm ${DESTDIR}${MANPREFIX}/man1/yaxwm.1

.PHONY: all options clean install uninstall
