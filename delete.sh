#!/bin/bash
cd "$(dirname "$0")"
clear
grep -n "add(" data.js
read -p "Line to delete: " n
sed -i "" "${n}d" data.js
echo "Done."