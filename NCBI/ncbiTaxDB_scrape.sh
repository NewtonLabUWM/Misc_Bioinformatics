#!/bin/sh


#####################################
### extract taxonomy information from 
### Kaiju alignment output
### Lou LaMartina, May 18 2022
#####################################


# go to files, make folder for results
cd RData
mkdir NCBI_taxonomy


# NCBI IDs that aligned with my contigs -
# see 04_metagenome_dataPrep.R
input="04_ncbi_data.txt"


# scrape text from ncbi page for respective IDs
while IFS= read -r line
do
	echo $line
	lynx -dump https://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?id=$line > ./NCBI_taxonomy/tax_$line.txt
done < "$input"


# # # # # # 


# go to files, make folder for results
cd NCBI_taxonomy
mkdir Lineage


# taxonomy info starts at a line saying "Lineage"
# grab that line plus the next 10 lines
for file in *.txt; do
	grep -A10 "Lineage" $file > Lineage/lineage-$file
done


# # # # # # # 


# go to files, make folder for results
cd RData/NCBI_taxonomy/Lineage
mkdir sed


# get rid of all the junk
for file in *.txt; do
	sed 's/\[[0-9]*]//g' $file |\
	tr -d " \t\n\r" |\
	sed 's/Lineage(full)//g' |\
	sed 's/;/,/g' | sed 's/\*/,/g' |\
	sed 's/\.//g' | sed 's/://g' |\
	sed 's/Click.*//g' | sed 's/Entrez.*//g' > sed/sed-$file
done
