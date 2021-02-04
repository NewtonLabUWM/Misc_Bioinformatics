#!/bin/sh


##########################################
### download multiple files from NCBI SRA
### using text file with run numbers
### Lou LaMartina, Jan 27 2020 
##########################################


# this bioproject has 36 samples,
# with run numbers in a series from
# SRR11487869 to SRR11487904

# a text file named "SRA_runs.txt" has
# the runs i want, each in a new line


input="*_runs.txt"


while IFS= read -r line
do
  printf "\n\nDownloading " ; printf $line; echo " . . . \n"
  fastq-dump --outdir fastq --gzip --skip-technical --readids --read-filter pass --dumpbase --split-3 --clip $line
done < "$input"
