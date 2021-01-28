#!/bin/sh


############################################
### trimming primer sequences from
### regions V4-V5 of 16S rRNA gene sequences
### Lou LaMartina, Jan 15 2021
############################################


# be in directory where raw reads are stored.
# make sure the file "v4v5_revs.fasta" is in
# this directory as well.


# trimmed reads will be sorted into new directories,
# ./fastqF and ./fastqR, inside ./cutadapt.

# output for each file will be stored in a text file.


mkdir cutadapt

for fileR1 in *_R1*; do
	fileR2=${fileR1/R1/R2}
	printf "\nTrimming ${fileR1} and ${fileR2} . . .\n"
	cutadapt -g "CCAGCAGCYGCGGTAAN" -G file:v4v5_revs.fasta \
	-m 50 -o cutadapt/$fileR1 -p cutadapt/$fileR2 \
	$fileR1 $fileR2 >> v4v5_cutadapt_output.txt
done

cd cutadapt

mkdir fastqF
mkdir fastqR

mv *R1* fastqF
mv *R2* fastqR
