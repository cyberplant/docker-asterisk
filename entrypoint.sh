#!/bin/sh


compile_dahdi() {
  # If dahdi is already configured/installed, exit
  type dahdi_cfg && return 

  set -e

  cd /usr/asterisk-src/dahdi-linux* 
  make
  make install

  cd /usr/asterisk-src/libpri*
  make
  make install

  # Recompile asterisk with dahdi
  cd /usr/asterisk-src/asterisk-13* 
  ./configure --with-pjproject-bundled
  make menuselect.makeopts 
  menuselect/menuselect --list-options 
  make 
  make install 
}

start_asterisk() {
    /usr/sbin/asterisk -vvvvdd
}

CMD="$1"

case $CMD in
  start)
    start_asterisk
    ;;
  start-with-dahdi)
    compile_dahdi
    start_asterisk
    ;;
  *)
    shift
    $CMD "$@"
    ;;
esac

