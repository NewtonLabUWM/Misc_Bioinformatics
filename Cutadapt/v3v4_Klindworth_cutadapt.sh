#!/bin/sh


############################################
### trimming primer sequences from
### regions V3-V4 of 16S rRNA gene sequences
### Lou LaMartina, Feb 9 2021
############################################


# primer source:
# https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3592464/

# trimmed reads will be sorted into new directories,
# ./fastqF and ./fastqR, inside ./cutadapt.

# output for each file will be stored in a text file.

# note: may need to change "pass_1" and "pass_2" to however
# else the forward and reverse reads are named, eg. R1 / R2
# (this format is used when downloading from SRA)


mkdir cutadapt

for fileR1 in *pass_1*; do
	fileR2=${fileR1/pass_1/pass_2}
	printf "\nTrimming ${fileR1} and ${fileR2} . . .\n"
	cutadapt -g "CCTACGGGNGGCWGCAG" -G "GACTACHVGGGTATCTAATCC" \
	-m 50 -o cutadapt/$fileR1 -p cutadapt/$fileR2 \
	$fileR1 $fileR2 >> Klindworth_v3v4_cutadapt_output.txt
done

cd cutadapt

mkdir fastqF
mkdir fastqR

mv *pass_1* fastqF
mv *pass_2* fastqR
