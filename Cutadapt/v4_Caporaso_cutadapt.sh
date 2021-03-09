#!/bin/sh


#########################################
### trimming primer sequences from
### regions V4 of 16S rRNA gene sequences
### Lou LaMartina, Sep 1 2020
#########################################


# primer source:
# https://www.pnas.org/content/108/Supplement_1/4516

# be in directory where raw reads are stored.

# trimmed reads will be sorted into new directories,
# ./fastqF and ./fastqR, inside ./cutadapt.

# output for each file will be stored in a text file.


mkdir cutadapt

for fileR1 in *_R1*; do
	fileR2=${fileR1/R1/R2}
	printf "\nTrimming ${fileR1} and ${fileR2} . . .\n"
	cutadapt -g "GTGCCAGCMGCCGCGGTAA" -G "GGACTACHVGGGTWTCTAAT " \
	-m 50 -o cutadapt/$fileR1 -p cutadapt/$fileR2 \
	$fileR1 $fileR2 >> v4_cutadapt_output.txt
done

cd cutadapt

mkdir fastqF
mkdir fastqR

mv *R1* fastqF
mv *R2* fastqR
