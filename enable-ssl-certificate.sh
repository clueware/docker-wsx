#!/bin/bash

if [ `grep -sco '# WSX SSL-CERTIFICATES GENERATION' Dockerfile` -gt 0 ]; then
	(>&2 echo "")
	(>&2 echo "Do not run this script twice!")
	(>&2 echo "If you want to start over, first delete")
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


CERT_FILE="/etc/vmware/wsx/ssl/wsx.crt"
KEY_FILE="/etc/vmware/wsx/ssl/wsx.key"

echo ""
cat <<"EOT"
-----
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
EOT
read -r -p "Country Name (2 letter code) [AU]: " COUNTRY_NAME
read -r -p "State or Province Name (full name) [Some-State]: " STATE_NAME
read -r -p "Locality Name (eg, city) []: " LOCALITY_NAME
read -r -p "Organization Name (eg, company) [Internet Widgits Pty Ltd]: " ORGANIZATION_NAME
read -r -p "Organizational Unit Name (eg, section) []: " ORGANIZATIONAL_UNIT
read -r -p "Common Name (e.g. server FQDN or YOUR name) []: " COMMON_NAME
read -r -p "Email Address []: " EMAIL_ADDRESS
echo "---"

CONFIG_FILE=`mktemp --suffix .cnf OpenSSLXXXXXX`

cat <<EOF >$CONFIG_FILE
[ req ]
default_bits		= 2048
default_days		= 365

prompt			= no
distinguished_name	= req_distinguished_name

[ req_distinguished_name ]

0.organizationName	= $ORGANIZATION_NAME
organizationalUnitName	= $ORGANIZATIONAL_UNIT
emailAddress		= $EMAIL_ADDRESS
localityName		= $LOCALITY_NAME
stateOrProvinceName	= $STATE_NAME
countryName		= $COUNTRY_NAME
commonName		= $COMMON_NAME
EOF


sed -i "/EXPOSE [0-9]\+/i # WSX SSL-CERTIFICATES GENERATION\n" Dockerfile

sed -i "/EXPOSE [0-9]\+/i ADD $CONFIG_FILE /tmp/\n" Dockerfile

sed -i "/EXPOSE [0-9]\+/i RUN mkdir -p $(dirname $CERT_FILE)\n" Dockerfile
sed -i "/EXPOSE [0-9]\+/i RUN mkdir -p $(dirname $KEY_FILE)\n" Dockerfile
sed -i "/EXPOSE [0-9]\+/i RUN openssl req -new -x509 -nodes -keyout $KEY_FILE -out $CERT_FILE -config /tmp/$(basename $CONFIG_FILE)\n" Dockerfile
