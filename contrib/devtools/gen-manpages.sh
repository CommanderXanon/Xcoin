#!/usr/bin/env bash

export LC_ALL=C
TOPDIR=${TOPDIR:-$(git rev-parse --show-toplevel)}
BUILDDIR=${BUILDDIR:-$TOPDIR}

BINDIR=${BINDIR:-$BUILDDIR/src}
MANDIR=${MANDIR:-$TOPDIR/doc/man}

XCOIND=${XCOIND:-$BINDIR/xcoind}
XCOINCLI=${XCOINCLI:-$BINDIR/xcoin-cli}
XCOINTX=${XCOINTX:-$BINDIR/xcoin-tx}
XCOINQT=${XCOINQT:-$BINDIR/qt/xcoin-qt}

[ ! -x $XCOIND ] && echo "$XCOIND not found or not executable." && exit 1

# The autodetected version git tag can screw up manpage output a little bit
XCNVER=($($XCOINCLI --version | head -n1 | awk -F'[ -]' '{ print $6, $7 }'))

# Create a footer file with copyright content.
# This gets autodetected fine for xcoind if --version-string is not set,
# but has different outcomes for xcoin-qt and xcoin-cli.
echo "[COPYRIGHT]" > footer.h2m
$XCOIND --version | sed -n '1!p' >> footer.h2m

for cmd in $XCOIND $XCOINCLI $XCOINTX $XCOINQT; do
  cmdname="${cmd##*/}"
  help2man -N --version-string=${XCNVER[0]} --include=footer.h2m -o ${MANDIR}/${cmdname}.1 ${cmd}
  sed -i "s/\\\-${XCNVER[1]}//g" ${MANDIR}/${cmdname}.1
done

rm -f footer.h2m
