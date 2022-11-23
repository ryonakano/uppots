#!/bin/bash
# uppots: Detect *.vala files with gettext syntax and update POTFILES accordingly

# The gettext functions in Vala
QUERY="((|Q|N|NC)\_|(d|dc|n|dn)gettext|dpgettext(2)?)\s?\(\""

if [[ $# -lt 3 ]]; then
	echo "Usage: $(basename $0) [project path] [POFILES path] [source path...]"
	exit 1
fi

PROJECT_PATH="$1"
POTFILES_PATH="$2"
shift 2
SOURCE_PATH="$*"

cd $PROJECT_PATH
FILES=($(find $SOURCE_PATH -type f | xargs egrep -l "${QUERY}" | sort -V))

truncate --size=0 $POTFILES_PATH

for FILE in ${FILES[@]}; do
	echo ${FILE#./} >> $POTFILES_PATH
done
