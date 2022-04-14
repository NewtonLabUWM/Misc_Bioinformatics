#!/bin/sh


##################################
### trimming primer sequences from
### pacbio-generated full 16S rRNA 
### gene amplicons
### Lou LaMartina, Feb 24 2022
##################################


# pacbio does not create paired-end reads like illumina,
# so there is no R1 & R2 files. instead, files consist of
# long reads that can be either the F or R of a given strand
# (so many are reverse complements of each other).
# both F and R primers are on the 5' ends.


# 27F - AGRGTTYGATYMTGGCTCAG
# 1492R - RGYTACCTTGTTACGACTT



mkdir cutadapt
mkdir info
mkdir ./info/R


for file in *.fastq.gz; do

	printf "\nTrimming ${file} . . .\n"

	cutadapt -g "AGRGTTYGATYMTGGCTCAG" -g "RGYTACCTTGTTACGACTT" \
	--info-file=./info/info_$file.txt --revcomp --quiet \
	-m 50 -o cutadapt/trim-$file $file

	awk -F "\t" '{ print $1, $2 }' ./info/info_$file.txt > ./info/R/info_1-2_$file.txt
	
done




##################
### info files ###
##################

# the info file outputs shows reads that matched
# which primer, reads that did not match, and reads that were
# reverse complements of a given primer



# columns:

# ADAPTER NOT FOUND	-
# 1		Read name
# 2		The value -1
# 3		The read sequence
# 4		Quality values


# ADAPTER FOUND	
# 1		Read name (with " rc" appended to end if reverse complement)
# 2		Number of errors
# 3		0-based start coordinate of the adapter match
# 4		0-based end coordinate of the adapter match
# 5		Sequence of the read to the left of the adapter match (can be empty)
# 6		Sequence of the read that was matched to the adapter
# 7		Sequence of the read to the right of the adapter match (can be empty)
# 8		Name of the found adapter.
# 9		Quality values corresponding to sequence left of the adapter match (can be empty)
# 10	Quality values corresponding to sequence matched to the adapter (can be empty)
# 11	Quality values corresponding to sequence to the right of the adapter match (can be empty)



# for the easiest way to look at it in R -

# > info <- read.table("info_[file]_1-2.txt", sep = " ", header = F, fill = T)[-3]
# > colnames(info)[1] <- "read"
# > info$num <- as.numeric(sapply(strsplit(info$read, "/"), '[', 2))
# > info$status <- NA
# > info$status[info$V2 == -1] <- "notfound"
# > info$status[info$V2 == "rc"] <- "revcomp"
# > info$status[! info$V2 %in% c(-1, "rc")] <- "found"
# > info <- info[-2]



# produces a data frame that looks like this -

#                           read num status1
# 1 m64120_210318_130156/105/ccs 105 revcomp
# 2 m64120_210318_130156/122/ccs 122   found
# 3 m64120_210318_130156/212/ccs 212   found
# 4 m64120_210318_130156/216/ccs 216 revcomp
# 5 m64120_210318_130156/240/ccs 240 revcomp
# ...
