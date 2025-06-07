#!/bin/bash
# uppots: Detect *.vala files with gettext syntax and update POTFILES accordingly

# The gettext functions in Vala
QUERY="((|Q|N|NC)\_|(d|dc|n|dn)gettext|dpgettext(2)?)\s?\(\""

usage()
{
	echo "Usage: $(basename $0) [project path] [POFILES path] [source path...]"
	exit 1
}

# Remove files under the source paths from POTFILES
remove_source()
{
	local -r POTFILES="$1"
	local -r SOURCE="$2"

	# e.g. "src/ lib" → "src/\|lib"
	local -r SOURCE_REG=${SOURCE// /\\|}
	sed -i -e "s@^\($SOURCE_REG\).*@@g" -e "/^$/d" $POTFILES
}

if [ $# -lt 3 ]; then
	usage
fi

PROJECT_PATH="$1"
POTFILES_PATH="$2"
shift 2
SOURCE_PATH="$*"

cd $PROJECT_PATH

remove_source $POTFILES_PATH "$SOURCE_PATH"

FILES=($(find $SOURCE_PATH -type f | xargs egrep -l "${QUERY}" | sort -V))

for FILE in ${FILES[@]}; do
	echo ${FILE#./} >> $POTFILES_PATH
done

sort $POTFILES_PATH -o $POTFILES_PATH
