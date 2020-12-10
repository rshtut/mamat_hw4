#!/bin/bash

wget "https://www.ynetnews.com/category/3082" -q
grep  -o article/......... 3082 | sort -u > articles.txt

phrases_to_check=(
	"Netanyahu"
	"Gantz"
)
rm results.csv
grep -o -i article articles.txt | wc -l >> results.csv

input="articles.txt"

while IFS= read -r line
do
	count=(0 0)
	i=0
	for phrase in ${phrases_to_check[@]}
	do
		wget -O article_to_check "https://www.ynetnews.com/$line" -q
		count[$i]=$(grep -o -i $phrase article_to_check | wc -l)
		let "i=i+1"
		rm article_to_check
	done
	if [ ${count[0]} -eq 0 -a ${count[1]} -eq 0 ]; then
		echo "https://www.ynetnews.com/$line, -" >> results.csv
	else
		echo "https://www.ynetnews.com/$line,"\
		"Netanyahu, ${count[0]}, Gantz, ${count[1]}" >> results.csv
	fi
done<$input

rm 3082
rm articles.txt