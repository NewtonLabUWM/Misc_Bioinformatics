#!/bin/sh

##################################
### mining mobile genetic elements
### Lou LaMartina, Apr 27, 2022
##################################


###############
### install ###
###############

# https://github.com/clb21565/mobileOG-db/blob/main/mobileOG-pl/UsageGuidance.md


# # download all data
# https://mobileogdb.flsi.cloud.vt.edu/entries/database_download


# # download repository
# https://github.com/clb21565/mobileOG-db


# # dependencies
# conda create -n mobileOGenv python=3.6.15
# conda activate mobileOGenv
# conda install -c conda-forge biopython
# conda install -c bioconda prodigal
# conda install -c bioconda diamond
# conda install pandas
# conda install argparse
# conda install itertools


# # go to downloaded directory
# cd mobileOG/beatrix-1-5_v1_all/


# # make diamond database
# diamond makedb --in mobileOG-db-beatrix-1.5.All.faa -d mobileOG-db-beatrix-1.5.All.dmnd


# # move all that and contigs into same directory


# # make executable
# chmod u+x mobileOGs-pl-kyanite.sh




#############
### fixes ###
#############

# in the mobileOGs-pl-kyanite.sh script, change 
# mobileOGs-pl.py -> mobileOGs-pl-kyanite.py


# in the mobileOGs-pl-kyanite.py script, change line 19 to
# df_OUT=pd.read_csv(args.i,sep="\t",encoding='ascii')

# and line 61 to
# Metadata=pd.read_csv('mobileOG-db-beatrix-1.5.All.csv',encoding='utf-8')




###############
### execute ###
###############

mkdir mobileOG

for file in *.fa; do
    filename="${file%.*}"
    filename=`basename $filename`
    mkdir ./mobileOG/$filename
	./mobileOGs-pl-kyanite.sh -i $file \
		-d mobileOG-db-beatrix-1.5.All.dmnd \
		-k 15 -e 1e-20 -p 90 -q 90 \
		> $filename.txt
		mv $filename* ./mobileOG/$filename
done
