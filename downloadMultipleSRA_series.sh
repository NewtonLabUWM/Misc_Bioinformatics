#!/bin/sh


##########################################
### download multiple files from NCBI SRA
### using Beattie et al 2020 (PRJNA622864)
### Lou LaMartina, Jan 27 2020 
##########################################


# this bioproject has 36 samples,
# with run numbers in a series from
# SRR11487869 to SRR11487904

# using SRR11487 as the prefix, then
# appending 869 through 904 to the ends

# the command fastq-dump is from sra-tools
# https://anaconda.org/bioconda/sra-tools

# parameter details
# https://ncbi.github.io/sra-tools/fastq-dump.html


for file in $(seq 869 904 | sed 's/[^ ]* */SRR11487&/g'); do
	printf "\n\nDownloading " ; printf $file; echo " . . . \n\n"
	fastq-dump --outdir fastq --gzip --skip-technical --readids --read-filter pass --dumpbase --split-3 --clip $file
done

