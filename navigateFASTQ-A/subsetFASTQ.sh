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
    	echo "\n. . . Unzipping" $gzipped ". . ."
    	gunzip $gzipped
    else
    	echo "\nWe already unzipped these files!\n"
    fi
done




##################
### subsetting ###
##################

echo

mkdir Subsetted



for unzipped in *.fastq; do
    output=./Subsetted/sub_$unzipped
    if [ ! -e $output ]; then
        echo "\n\nSubsetting . . .\n" $unzipped ". . ."
        head -n 5000 $unzipped > ./Subsetted/sub_$unzipped
    else
        echo $output
        echo "\nWe already subsetted these files!\n\n"
    fi
done




##############
### re-zip ###
##############


# raw files
for unzipped in *.fastq; do
    if [ -e "$unzipped" ]; then
        echo "\n. . . Zipping" $unzipped ". . ."
        gzip $unzipped
    else
        echo "\nRaw files already zipped back up!\n"
    fi
done



# subsetted files
cd Subsetted

for unzipped in *.fastq; do
    if [ -e "$unzipped" ]; then
        echo "\n. . . Zipping" $unzipped ". . ."
        gzip $unzipped
    else
        echo "\nSubsetted files already zipped back up!\n"
    fi
done



# # results
# echo "\n\nCounting raw reads . . ."
# grep -c "@" *.fastq > numReads_raw.txt

# echo "\n\nCounting subsetted reads . . ."
# grep -c "@" ./Subsetted/*.fastq > numReads_subbed.txt
# echo


echo "Done!"
