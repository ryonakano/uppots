#!/bin/bash
# uppots: Detect *.vala files with gettext syntax and update POTFILES accordingly

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

add_source()
{
	local -r POTFILES="$1"
	local -r SOURCE="$2"
	# The gettext functions in Vala
	# See also: https://www.gnu.org/software/gettext/manual/html_node/Vala.html
	local -r L10N_QUERY="((|Q|N|NC)_|(d|dc|n|dn)gettext|dpgettext(2)?)\s?\(\""

	local -r L10N_SOURCES=($(find $SOURCE -type f | xargs grep -l -E "${L10N_QUERY}" | sort -V))

	for L10N_SOURCE in ${L10N_SOURCES[@]}; do
		echo ${L10N_SOURCE#./} >> $POTFILES
	done
}

if [ $# -lt 3 ]; then
	usage
fi

readonly PROJECT_PATH="$1"
readonly POTFILES_PATH="$2"
shift 2
readonly SOURCE_PATH="$*"

pushd $PROJECT_PATH > /dev/null

remove_source $POTFILES_PATH "$SOURCE_PATH"
add_source $POTFILES_PATH "$SOURCE_PATH"

sort $POTFILES_PATH -o $POTFILES_PATH

popd > /dev/null # PROJECT_PATH
