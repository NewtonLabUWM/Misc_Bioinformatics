#!/bin/bash


###########################################
### processing multiple FASTAs with Metaxa2
### Lou LaMartina, started April 26, 2021
###########################################


###############
### install ###
###############

# https://microbiology.se/software/metaxa2/
# cd Metaxa2_2.2.3/
# ./install_metaxa2




####################
### dependencies ###
####################

# conda install -c bioconda hmmer 
# conda install -c bioconda mafft 

# perl -v
# hmmscan -h
# mafft -v
# blastn -version

# unzipped files only!!




###############
### execute ###
###############

# ignore file types that aren't present
shopt -s nullglob


# iterate over fastas
for file in ./Contigs/*.{fa,fna,fa,fasta}; do
    filename="${file%.*}"
    filename=`basename $filename`
    mkdir ./Metaxa2/$filename
	echo "\n . . . Working on" $filename ". . ."
	metaxa2 -i $file -o ./Metaxa2/$filename/$filename --plus T -g ssu
done
