#!/bin/bash


###########################################
### processing multiple FASTQs with Metaxa2
### Lou LaMartina, started April 28, 2021
###########################################


# install & info
# https://microbiology.se/software/metaxa2/


####################
### dependencies ###
####################

# cd Metaxa2_2.2.3/
# ./install_metaxa2

# conda install -c bioconda hmmer 
# conda install -c bioconda mafft 

# perl -v
# hmmscan -h
# mafft -v
# blastn -version




###############
### execute ###
###############

# iterate over fastqs
for fileR1 in *_R1*; do
	fileR2=${fileR1/_R1/_R2}
    filename="${fileR1%_R1*}"
    filename=`basename $filename`
    mkdir ./Metaxa2/$filename
	echo "\n\n . . . Working on" $filename ". . .\n"
	metaxa2 -1 $fileR1 -2 $fileR2 -o ./Metaxa2/$filename/$filename --plus T -g ssu
done
