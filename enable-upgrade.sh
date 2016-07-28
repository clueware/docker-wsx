#!/bin/bash

if [ `grep -sco '# WSX OPTIONAL BETA UPGRADE' Dockerfile` -gt 0 ]; then
	(>&2 echo "")
	(>&2 echo "The optional Beta Upgrade is already enabled.")
	(>&2 echo "")
	(>&2 echo "If you want to disable it, first delete")
	(>&2 echo "the \"Dockerfile\" and rename the")
	(>&2 echo "\"Dockerfile.orig\" to \"Dockerfile\"")
	(>&2 echo "using the commands")
	(>&2 echo "")
	(>&2 echo "  rm -iv ./Dockerfile")
	(>&2 echo "  mv -v ./Dockerfile{.orig,}")
	(>&2 echo "")
	exit 1
fi

# Create a Backup
if [ -f ./Dockerfile.orig ]; then
	(>&2 echo "")
	(>&2 echo "The Backup \"Dockerfile.orig\" already exists.")

        NOBACKUP=""
        while [ -z "$NOBACKUP" ]; do
                read -r -n1 -p "Proceed with no (additional) backup of \"Dockerfile\" [y/n] ? " NOBACKUP
                if [[ $NOBACKUP = "" ]]; then
                        continue
                else
                case "$NOBACKUP" in
                        "n"|"N"|$'\e') (>&2 echo "")
                                (>&2 echo "Aborting.")
                                exit 1
                                ;;
                        "y"|"Y") NOBACKUP="true"
                                ;;
                        *) NOBACKUP=""
                                ;;
                esac
                fi
                (>&2 echo "")
        done

else
	cp ./Dockerfile ./Dockerfile.orig
fi

echo -n "Enabling optional WSX Beta Upgrade... "

sed -i "/EXPOSE [0-9]\+/i # WSX OPTIONAL BETA UPGRADE\n" Dockerfile

sed -i "/EXPOSE [0-9]\+/i ADD VMware-WSX-1.1.0-1158072.x86_64.bundle /tmp/\n" Dockerfile
sed -i "/EXPOSE [0-9]\+/i RUN chmod a+x /tmp/VMware-WSX-1.1.0-1158072.x86_64.bundle\n" Dockerfile
sed -i "/EXPOSE [0-9]\+/i RUN expect /tmp/upgrade_wsx.expect\n" Dockerfile

echo "Done."
