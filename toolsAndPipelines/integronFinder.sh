#################################
### mining integrons from contigs
### Lou LaMartina, Apr 27, 2022
#################################


# https://integronfinder.readthedocs.io/en/latest/user_guide/tutorial.html


###############
### install ###
###############

#conda create -n IFenv
#conda activate IFenv
#conda install -c bioconda integron_finder


# need to use older version of colorlog, otherwise will get error:
# "AttributeError: module 'colorlog' has no attribute 'logging'"
#conda install colorlog=4.8.0




##############
### output ###
##############

# 3 files under Results_Integron_Finder_mysequences:

# mysequences.integrons
# A file with all integrons and their elements detected in all sequences in the input file.

# mysequences.summary
# A summary file with the number and type of integrons per sequence.

# integron_finder.out
# A copy standard output. The stdout can be silenced with the argument --mute



###############
### execute ###
###############

mkdir integronFinder
cd integronFinder


# ignore file types that aren't present
shopt -s nullglob


# iterate over fastas
for file in ../Contigs/*.{fa,fna,fa,fst,fasta}; do
	now=$(date +"%T")
	echo "\n$now : Working on" $file ". . ."
	integron_finder $file
done
