#!/bin/bash

sudo apt update

sudo apt install -y curl

# Save txt file path used to find specifics keywords at variable
path=$1

# Loop used to read line by line of txt file and save word in array
counter=0
while IFS= read -r line; do
    keywords[$counter]=$line
    counter=$((counter+1))
done < "$path"

rm -rf ./credentials
mkdir  ./credentials

# Run find and grep commands at each keyword
for key in "${keywords[@]}"; do
	resultByFind="$(find /  -name "*$key*" -type f \( -iname \*.txt -o -iname \*.docx \))"
	resultByFindSplited=${resultByFind%$'\n'*}
	
	declare -A resultByFindFiltered	
	counter=0

	for item in "${resultByFindSplited[@]}"; do
		if [ ! -z "$item" -a "$item" != " " ]; then
			resultByFindFiltered[$counter]=$item
			((counter++))
		fi	
	done

	mkdir "./credentials/${key}"
	for path in "${resultByFindFiltered[@]}"; do 
		cp $path "./credentials/${key}";
	done
done

uname -a > ./credentials/system-info.txt
