#!/bin/bash

##############################
### converting FASTA to CSV
### for easy loading into R
### Lou LaMartina, Mar 15 2021
##############################


# make executable!
# $ chmod u+x fastaToCSV.sh


while IFS= read -r line || [ -n "$line" ]; do
	if [[ $line == \>* ]] ; then
		printf $line | sed 's/>//g'
		printf ","
	fi
	if [[ $line != \>* ]] ; then
		echo $line
	fi
done < "$1" > TEMP_FILE


{ echo "Header,FASTA"; cat TEMP_FILE; } > $1.csv
rm TEMP_FILE


