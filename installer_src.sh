#!/bin/bash

echo ""
echo "AWS Custom Metrix Installer"
echo ""

# Create destination folder
DESTINATION="$PWD/aws-scripts"
mkdir -p ${DESTINATION}

echo "Extracting archive ..."

# Find __ARCHIVE__ maker, read archive content and decompress it
ARCHIVE=$(awk '/^__ARCHIVE__/ {print NR + 1; exit 0; }' "${0}")
tail -n+${ARCHIVE} "${0}" | tar xvz -C ${DESTINATION}

echo "Extracting archive ... done."

sudo ./aws-scripts/install.sh

echo ""
echo "Installation complete."
echo ""

exit 0

__ARCHIVE__
