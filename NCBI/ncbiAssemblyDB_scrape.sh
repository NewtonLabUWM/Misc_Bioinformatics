#!/bin/sh


######################################
### extract biosample information from 
### list of NCBI assembly IDs
### Lou LaMartina, May 18 2022
######################################


# conda install -c bioconda entrez-direct


# assembly IDs - extracted from file names from NCBI contigs
input="assemblies.txt"



# scrape the assembly database webpage for
while IFS= read -r assemb; do
	lynx -dump https://www.ncbi.nlm.nih.gov/assembly/$assemb > tmp.txt
	link=$(grep "https://www.ncbi.nlm.nih.gov/biosample?LinkName=assembly_biosample&from_uid=" tmp.txt)

	# biosample IDs
	smp=$(lynx -dump $link | grep -A1 "Identifiers" | grep -v "Identifiers" | cut -f1 -d";" | sed 's/BioSample: //g')
	
	# bioproject IDs
	bp=$(lynx -dump $link | grep "PRJ" | sed -e 's/\[[^][]*\]//g' | awk '{$1=$1};1' | cut -d" " -f1)
	echo $bp $smp $assemb >> bioprojects.txt
	rm tmp.txt
done < "$input"



# with the bioproject IDs, get 
bps=$(cut -d" " -f1 bioprojects.txt | grep "PRJ"| uniq)

for bp in $bps; do

	# sample information (biosample attributes)
	esearch -db bioproject -query $bp |\
	elink -target sra | efetch -format docsum |\
	xtract -pattern SampleData -element Attribute > ./Metadata/$bp-attributes.txt

	# sequence file information (SRA metadata)
	esearch -db sra -query $bp | efetch -format runinfo > ./Metadata/$bp-metadata.txt
done
