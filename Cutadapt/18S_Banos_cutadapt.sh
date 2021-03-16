#!/bin/sh


##################################
### trimming primer sequences from
### fungal 18S rRNA gene sequences
### Lou LaMartina, Mar 15 2021
##################################


# primer source:
# https://bmcmicrobiol.biomedcentral.com/articles/10.1186/s12866-018-1331-4

# be in directory where raw reads are stored.

# trimmed reads will be sorted into new directories,
# ./fastqF and ./fastqR, inside ./cutadapt.

# output for each file will be stored in a text file.


mkdir cutadapt

for fileR1 in *_R1*; do
	fileR2=${fileR1/R1/R2}
	printf "\nTrimming ${fileR1} and ${fileR2} . . .\n"
	cutadapt -g "TCGTCGGCAGCGTCAGATGTGTATAAGAGACAGCGATAACGAACGAGACCT" \
	-G "GTCTCGTGGGCTCGGAGATGTGTATAAGAGACAGANTACCGATTGAATGGNT " \
	-m 50 -o cutadapt/$fileR1 -p cutadapt/$fileR2 \
	$fileR1 $fileR2 >> 18S_cutadapt_output.txt
done

cd cutadapt

mkdir fastqF
mkdir fastqR

mv *R1* fastqF
mv *R2* fastqR
