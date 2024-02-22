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
	echo "Usage: check_links.sh [-d] [-a] mdfile"
	echo "The script will search the mdfile for pictures from hedgedoc and report the missing ones"
	echo "The option -d will also download the missing ones and suggest you git add them."
	echo "The option -a will not limit the links to be downloaded to images."
	exit 1
}

ispic()
{
	if test "$ALL" = "1"; then return 0; fi
	ext=${1##*.}
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
	fn=${1##*/}
	test -r $fn
}

# main

if test "$1" = "-d"; then DOWNLOAD=1; shift; fi
if test "$1" = "-a"; then ALL=1; shift; fi
if test -z "$1" -o "$1" = "-h"; then usage; fi
if test ! -r "$1"; then echo "ERROR: File \"$1\" not readable" 1>&2; exit 2; fi
INPATH=${1%/*}
INFILE=${1##*/}
if test "$INPATH" != "$1"; then cd $INPATH; INPATH="${INPATH}/"; else INPATH=""; fi

ADDS=""
errs=0
while read line; do
	# FIXME: Handle multiple links in one line
	LINK="$(echo $line | sed 's@^.*\(https://input.scs.community/[^) #"]*\).*$@\1@')"
	LINK="${LINK%\'}"
	if ispic $LINK; then
		if exist $LINK; then 
			echo "$LINK present already"
		else
			echo "$LINK missing"
			if test "$DOWNLOAD" = "1"; then
				curl -LO "$LINK"
				if test $? = "0"; then echo "Downloaded $LINK successfully."; ADDS="$ADDS ${INPATH}${LINK##*/}"
				else echo "ERROR downloading $LINK" 1>&2; let errs+=1; fi
			else
				let errs+=1
			fi
		fi
	fi
done < <(tr ' ' '\n' < "$INFILE"|grep 'https://input.scs.community'|sed 's/!\[..*\]//g')
if test "$DOWNLOAD" -a -n "$ADDS"; then
	echo -e "Consider\ngit add $ADDS"
fi
if test $errs -gt 0; then
	echo "$errs missing files" 1>&2
fi
exit $errs
