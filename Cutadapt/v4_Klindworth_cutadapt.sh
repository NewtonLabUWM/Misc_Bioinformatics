#!/bin/sh


############################################
### trimming primer sequences from
### regions V4 of 16S rRNA gene sequences
### Lou LaMartina, Jan 15 2021
############################################


# primer source:
# https://pubmed.ncbi.nlm.nih.gov/23793624/

# trimmed reads will be sorted into new directories,
# ./fastqF and ./fastqR, inside ./cutadapt.

# output for each file will be stored in a text file.


mkdir cutadapt

for fileR1 in *pass_1*; do
	fileR2=${fileR1/pass_1/pass_2}
	printf "\nTrimming ${fileR1} and ${fileR2} . . .\n"
	cutadapt -g "TATGGTAATTGTGTGCCAGCMGCCGCGGTAA" -G "AGTCAGTCAGCCGGACTACHVGGGTWTCTAAT" \
	-m 50 -o cutadapt/$fileR1 -p cutadapt/$fileR2 \
	$fileR1 $fileR2 >> v4_Kozich_cutadapt_output.txt
done

cd cutadapt

mkdir fastqF
mkdir fastqR

mv *pass_1* fastqF
mv *pass_2* fastqR
