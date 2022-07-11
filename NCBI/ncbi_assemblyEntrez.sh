#!/bin/sh


######################################
### extract biosample information from 
### list of NCBI assembly IDs
### Lou LaMartina, May 26 2022
######################################


# conda install -c bioconda entrez-direct
#			 new bffffff ^


# read list of assembly IDs
input="assemblies.txt"
assembs=$(cat $input)


# for each assembly
for assemb in $assembs; do

	# get its biosample ID
	bs=$(esearch -db assembly -query $assemb | efetch -format docsum | xtract -pattern DocumentSummary -element BioSampleAccn)

	# bioproject ID
	bp=$(esearch -db assembly -query $assemb | efetch -format docsum | xtract -pattern DocumentSummary -element BioprojectAccn)

	# title / organism name hopefully
	org=$(esearch -db biosample -query $bs | efetch -format docsum | xtract -pattern DocumentSummary -element Title)

    	# save all biosample data
    	esearch -db biosample -query $bs | efetch -format docsum > ./Metadata/all-$assemb.txt

    	# save select biosample data
    	echo $bp $bs $assemb $org > ./Metadata/sum-$assemb.txt
done
