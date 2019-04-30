#!/bin/bash

BK_DIR="$(pwd)/backups"
DW_DIR="${BK_DIR}/dokuwiki"

vol_dw_conf="dokuwiki-conf"
vol_dw_data="dokuwiki-data"
vol_dw_plugins="dokuwiki-plugins"
vol_dw_tpl="dokuwiki-tpl"
ugid="$(id -u):$(id -g)"

usage()
{
	echo -e "Usage: $(basename ${0}) -c|-e|-h|-i <file>"
	echo -e "\t-c,--clean\t\tClean backups directory"
	echo -e "\t-e,--export\t\tExport volumes"
	echo -e "\t-h,--help\t\tHelp menu (this message)."
	echo -e "\t-i,--import <file>\tImport an archive or a directory"
}

clean_directory()
{
	rm -fr "${DW_DIR}"
}

copy_v2a()
{
	volume="$1"
	directory="$2"
	docker run --rm \
		   -v "${volume}":/src \
		   -v "${directory}":/dst \
		   alpine sh -c "f=/dst/${volume}.tgz ; tar -zcf "'${f}'" src ; chown ${ugid} "'${f}'
}

copy_d2v()
{
	directory="$1"
	volume="$2"
	docker run --rm \
		   -v "${directory}":/src \
		   -v "${volume}":/dst \
		   alpine sh -c "cp -a /src/* /dst"
}

export_volumes()
{
	tag=$(date +%y%m%d%H%M%S)
	dw_tmp="dokuwiki-${tag}"
	tmp_dir="${BK_DIR}/${dw_tmp}"

	mkdir "${tmp_dir}"

	copy_v2a "${vol_dw_conf}" "${tmp_dir}"
	copy_v2a "${vol_dw_data}" "${tmp_dir}"
	copy_v2a "${vol_dw_plugins}" "${tmp_dir}"
	copy_v2a "${vol_dw_tpl}" "${tmp_dir}"

	cd "${BK_DIR}" || exit 1
	tar -cf "${dw_tmp}.tar" "${dw_tmp}"
	cd - || exit 1
	rm -fr "${tmp_dir}"
}

import_volumes()
{
	import_file="${import_file}"
	type_file=$(file "${1}" | cut -d":" -f2)
	case "${type_file}" in
		" directory")
			echo "Import a directory"
			copy_d2v "${DW_DIR}/conf" "${vol_dw_conf}"
			copy_d2v "${DW_DIR}/data" "${vol_dw_data}"
			copy_d2v "${DW_DIR}/lib/plugins" "${vol_dw_plugins}"
			copy_d2v "${DW_DIR}/lib/tpl" "${vol_dw_tpl}"
			;;
		" POSIX tar archive (GNU)")
			echo "Import a tar archive"
			;;
		*)
			echo "Is not a tar file or a directory"
			exit 1
			;;
	esac
}

[ "$#" -eq 0 ] && echo "No argument" && usage && exit 1
[ ! -d "${DW_DIR}" ] && echo "Your directory is empty"  && exit 1

while [ '-' = "${1:0:1}" ]
do
	case "${1}" in
		-c|--clean)
			clean_directory
			;;
		-e|--export)
			export_volumes
			;;

		-h|--help)
			usage
			exit 0
			;;

		-i|--import)
			shift
			file="${1}"
			if [ ! -e "${file}" ]
			then
				echo "Bad file"
				usage
				exit 1
			fi
			import_volumes "${file}"
			;;

		*)
			echo "Bad argument"
			usage
			exit 1
			;;
	esac
	shift
done

exit 0
