#!/bin/bash
#
# Look for links from input.scs.community, typically pictures
# Optionally [-d] download them
#
# (c) Kurt Garloff <garloff@osb-alliance.com>, 01/2024
# SPDX-License-Identifier: CC-BY-SA-4.0
#

usage()
{
	echo "Usage: check_links.sh [-d] [-a] mdfile [mdfile [...]]"
	echo "The script will search the mdfile(s) for pictures from hedgedoc and report the missing ones"
	echo "The option -d will also download the missing ones and suggest you git add them."
	echo "The option -a will not limit the links to  images but all linked files."
	exit 1
}

ispic()
{
	ext="${1##*.}"
	ext="$(echo $ext | tr A-Z a-z)"
	case $ext in
		png|jpg|jpeg|heic|heif|svg|avif)
			return 0
			;;
	esac
	return 1
}

exist()
{
	test -r "$fn"
}

# main

if test "$1" = "-d"; then DOWNLOAD=1; shift; fi
if test "$1" = "-a"; then ALL=1; shift; fi
if test -z "$1" -o "$1" = "-h"; then usage; fi
if test ! -r "$1"; then echo "ERROR: File \"$1\" not readable" 1>&2; exit 2; fi

ADDS=""
errs=0

SEDCHANGES=""
while test -n "$1"; do
INPATH=${1%/*}
INFILE=${1##*/}
pushd . >/dev/null 2>&1
if test "$INPATH" != "$1"; then cd $INPATH; INPATH="${INPATH}/"; else INPATH=""; fi

echo "*** $INFILE ***"
CHANGES=""
while read line; do
	# FIXME: Handle multiple links in one line
	LINK1="$(echo $line | sed 's@^.*\(https://input.scs.community/[^) "]*\).*$@\1@')"
	LINK="${LINK1%\'}"
	LINKANCHOR="${LINK##*#}"
	if test "$LINK" = "$LINKANCHOR"; then LINKANCHOR=""; fi
	LINKNOANCHOR="${LINK%#*}"
	LINKNOVAR="${LINK%\?*}"
	LINKNONO="${LINKNOANCHOR%\?*}"
	TGTFILE="${LINKNONO##*/}"
	if test -z "$TGTFILE"; then continue; fi
	if test "$ALL" = "1" || ispic "$LINK"; then
		ERR=0
		echo " Consider replacing $LINK with $TGTFILE[.md] ..."
		if exist "$TGTFILE"; then
			echo " $TGTFILE present already"
		elif exist "$TGTFILE.md"; then
			TGTFILE="$TGTFILE.md"
			echo " $TGTFILE present already"
		else
			echo "$LINK missing"
			if test "$DOWNLOAD" = "1"; then
				if ispic "$LINK"; then
					curl -sLO "$LINK"
					ERR=$?
				else
					curl -sLO "$LINKNONO"/download
					ERR=$?
					TGTFILE="${TGTFILE}.md"
					mv download "$TGTFILE"
				fi
				if test $ERR = 0; then
					echo " Downloaded $LINK successfully."
					ADDS="$ADDS ${INPATH}${TGTFILE}"
				fi
			fi
		fi
		if test $ERR = 0; then
			if test -n "$LINKANCHOR"; then TGTFILE="$TGTFILE#$LINKANCHOR"; fi
			# We strip off variables here, but leave anchors in
			if echo "$line" | grep "(${LINK})" >/dev/null; then
				CHANGES="$CHANGES -e 's~${LINK}~${TGTFILE}~g'"
			elif echo "$link" | grep "<$LINK>" >/dev/null; then
				CHANGES="$CHANGES -e 's~<${LINK}[^>]*>~[${TGTFILE%#*}](${TGTFILE}~g'"
			else
				CHANGES="$CHANGES -e 's~${LINK}~[${TGTFILE%#*}](${TGTFILE})~g'"
			fi
		else echo "ERROR downloading $LINK" 1>&2; let errs+=1; fi
	fi
done < <(tr ' ' '\n' < "$INFILE"|grep 'https://input.scs.community'|sed 's/!\[..*\]//g')
if test -n "$CHANGES"; then SEDCHANGES="${SEDCHANGES}sed -i $CHANGES $1; "; fi
shift
popd >/dev/null 2>&1
done

if test "$DOWNLOAD" -a -n "$ADDS"; then
	echo -e "Consider\ngit add $ADDS"
	echo "$SEDCHANGES"
fi
if test $errs -gt 0; then
	echo "$errs missing files" 1>&2
fi
exit $errs
