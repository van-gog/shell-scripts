#!/bin/bash

#set -x

extension=".csv"
path=`pwd`
username=""
password=""
host=""
database_name=""


usage()
{
	echo ""
        echo "USAGE: $0 -s database [options]"
        echo "Options:"
	echo "	-e	Files extension (default '.csv')"
	echo "	-s	Database name"
	echo "	-d	Directory where CSV files located"	
	echo "	-u	MySQL Username"
	echo "	-p	MySQL Password"
	echo "	-h	MySQL Host"
	exit 0
}


if [[ $# -gt 0 ]]; then
	while getopts ":e:d:u:p:s:h:i" option; do
		case "$option" in
			e) 	extension="$OPTARG"
				;;
			d)	path="$OPTARG"
				;;
			u)	username="-u $OPTARG"
				;;
			p)	password="-p $OPTARG"
				;;
			s)	database_name="$OPTARG"
				;;
			h)	host="-h $OPTARG"
				;;
			\?)	echo "Illegal option: $OPTARG" >&2
				usage
				exit 1
				;;
			:)	echo "Option -$OPTARG requires an argument." >&2
				exit 1
				;;
		esac
	done
else
	usage
fi

if [[ -z "$database_name" ]]; then
	usage
else
	files_list=`ls $path/*$extension`
	for file_name in $files_list
	do
		base_name=`basename $file_name`
		table_name=`echo $base_name | sed "s/$extension//"`
		echo "Start import for table $table_name"
		mysql -e "SET foreign_key_checks = 0; load data local infile '"$path/$base_name"' into table $table_name" $username $password $host $database_name
		echo "Import for table $table_name completed"
	done
fi
