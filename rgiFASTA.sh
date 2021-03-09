#!/bin/sh -e


#####################################
### processing multiple FASTAs with
### resistance gene identifier (RGI)
### Lou LaMartina, started Mar 9 2021
#####################################


###############
### install ###
###############

# using virtual env

# $ conda init --all
# $ conda create --name rgi rgi=5.1.1
# $ conda activate rgi
# $ rgi --help




#######################
### before starting ###
#######################

# $ conda init --all
# $ conda activate rgi




#############
### unzip ###
#############

for gzipped in *gz; do
    if [ -e "$gzipped" ]; then
    	echo "\n . . . Unzipping" $gzipped " . . ."
    	gunzip $gzipped
    else
    	echo "\n No gzip files here."
    fi
done


for bzipped in *bz2; do
    if [ -e "$bzipped" ]; then
    	echo "\n . . . Unzipping" $bzipped " . . ."
    	gunzip $bzipped
    else
    	echo "\n No bzip2 files here."
    fi
done




###########
### RGI ###
###########


echo "\n . . . Loading CARD database . . . "
rgi load --card_json /Users/loulamartina/Documents/localDB/card.json --local


for file in *fna; do
	echo "\n . . . Aligning" $file "with CARD database . . . "
	rgi main --input_sequence $file \
	--output_file RGI_$file \
	--input_type contig \
	--local \
	--clean
done



