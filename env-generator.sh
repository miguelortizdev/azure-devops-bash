#!/bin/bash

TEMPLATE=.env.example
TARGET=.env.azure.sh
VAR_FORMAT='$%s'

 egrep -o '^(#*\w+)=' ${TEMPLATE} > .env.temporal

echo "#!/usr/bin/env bash" > ${TARGET}
echo "cat <<EOF > .env.azure" >> ${TARGET}

while IFS='=' read -r KEY; do
    KEY=$(echo "$KEY" | sed 's/=//g')
    if echo "$KEY" | grep -q "^#"; then
        KEY=$(echo "$KEY" | sed "s/#\+//g")
    fi

    NEW_KEY=$(printf $VAR_FORMAT $KEY)

    echo "$KEY=$NEW_KEY" >> ${TARGET}
done < .env.temporal

echo "EOF" >> ${TARGET}

sh .env.azure.sh
sed '/[A-Za-z_]=$/d' .env.azure > .env
rm .env.temporal .env.azure.sh .env.azure