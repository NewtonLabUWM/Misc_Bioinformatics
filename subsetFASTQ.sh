#!/bin/sh -e


##########################################
### subsetting PacBio fastq files to more
### efficiently learn error rates in DADA2
### Lou LaMartina, started Sep 22 2021
##########################################




#############
### unzip ###
#############

for gzipped in *.gz; do
    if [ -e "$gzipped" ]; then
    	echo "\n . . . Unzipping" $gzipped " . . ."
    	gunzip $gzipped
    else
    	echo "\nNo gzip files here!\n"
    fi
done




##################
### subsetting ###
##################

echo

mkdir Subsetted

echo "\n\nSubsetting . . .\n"

for unzipped in *.fastq; do
    output=./Subsetted/sub_$unzipped
    if [ ! -e $output ]; then
        head -n 5000 $unzipped > ./Subsetted/sub_$unzipped
    else
        echo $output
        echo "\nWe already changed these!\n\n"
    fi
done


# results
grep -c "@" *.fastq > numReads_raw.txt
grep -c "@" ./Subsetted/*.fastq > numReads_subbed.txt





##############
### re-zip ###
##############

for unzipped in *.fastq; do
    if [ -e "$unzipped" ]; then
        echo "\n . . . Zipping" $unzipped " . . ."
        gzip $unzipped
    else
        echo "\nAlready zipped back up!\n"
    fi
done

echo

echo "Done!"
