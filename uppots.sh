#!/bin/bash
# UpPots: Detect *.vala files with gettext syntax and update POTFILES accordingly

# The gettext functions in Vala
QUERY="((|Q|N|NC)\_|(d|dc|n|dn)gettext|dpgettext(2)?)\s?\(\""

if [[ $# -lt 2 ]]; then
	echo "Usage: uppots [project path] [search path...]"
	exit 1
fi

cd "$1"
FILES=($(find ${@:2} -type f | xargs egrep -l "${QUERY}" | sort))

POTFILES=po/POTFILES
truncate --size=0 $POTFILES

for FILE in ${FILES[@]}; do
	echo ${FILE#./} >> $POTFILES
done
