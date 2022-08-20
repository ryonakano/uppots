#!/bin/bash
# UpPots: Detect *.vala files with gettext syntax and update POTFILES accordingly

# The gettext functions in Vala
QUERY="((|Q|N|NC)\_|(d|dc|n|dn)gettext|dpgettext(2)?)\s?\(\""

if [[ $# -ne 1 ]]; then
	echo "Usage: uppots [source root path]"
	exit 1
fi

cd "$1"
FILES=($(find . -type f | xargs egrep -l "${QUERY}"))

POTFILES=po/POTFILES
truncate --size=0 $POTFILES

for FILE in ${FILES[@]}; do
	echo ${FILE#./} >> $POTFILES
done
