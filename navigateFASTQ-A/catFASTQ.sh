#!/bin/sh -e

####################################################
### concatenate fastq files with the same file names.
### one set was run on illumina nano flow cell, 
### the other on full flow cell.
### want to combine them into the same fastq files.
### Lou LaMartina, started April 9, 2020
###################################################

# cd ~/Desktop/Lab/Projects/Fei/


# make directories to put new data in
mkdir results

mkdir ./results/fastqF
mkdir ./results/fastqR

mkdir ./results/fastqF/nano
mkdir ./results/fastqF/full

mkdir ./results/fastqR/nano
mkdir ./results/fastqR/full





################
### forwards ###
################

# unzip nano flow files
NanoFfiles=./200219_Fei_fish_Nanoflow_v5v6/cutadapt/fastqF/*

for zip in $NanoFfiles; do
	if [ ${zip: -3} == ".gz" ]; then
		printf "\nUnzipping"
		basename $zip
		gunzip $zip
	else
		basename $zip
		printf "We already unzipped these!\n\n"
	fi
done



# unzip full flow files
FullFfiles=./200221_Fei_fish_FullFlow_v5v6/cutadapt/fastqF/*

for zip in $FullFfiles; do
	if [ ${zip: -3} == ".gz" ]; then
		printf "\nUnzipping"
		basename $zip
		gunzip $zip
	else
		basename $zip
		printf "We already unzipped these!\n\n"
	fi
done



# append -full or -nano to headers
for nanoF in $NanoFfiles; do
	output=./results/fastqF/nano/new-$(basename $nanoF)
	if [ ! -e $output ]; then
		printf "\n\nChanging fastq headers\n"
		basename $nanoF
		sed '/@M0/ s/$/ nano/' $nanoF > ./results/fastqF/nano/new-$(basename $nanoF)
		printf "\n\n"
	else
		basename $nanoF
		printf "We already changed these!\n\n"
	fi
done


for fullF in $FullFfiles; do
	output=./results/fastqF/full/new-$(basename $fullF)
	if [ ! -e $output ]; then
		printf "\n\nChanging fastq headers\n"
		basename $fullF
		sed '/@M0/ s/$/ nano/' $fullF > ./results/fastqF/full/new-$(basename $fullF)
		printf "\n\n"
	else
		basename $output
		printf "We already changed these!\n\n"
	fi
done

newNanoFfiles=./results/fastqF/nano/new-*



# concatenate full and nano fastq files
for newnanoF in $newNanoFfiles; do
	output=./results/fastqF/cat-$(basename $newnanoF)
	if [ ! -e $output ]; then
		newfullF=${newnanoF/nano/full}
		printf "\nCombining\n"
		basename $newnanoF
		basename $newfullF
		cat $newnanoF $newfullF > ./results/fastqF/cat-$(basename $newnanoF)
		printf "\n\n"
	else
		basename $output
		printf "We already combined these!\n\n"
	fi
done





################
### reverses ###
################

# unzip nano flow files
nanoRfiles=./200219_Fei_fish_Nanoflow_v5v6/cutadapt/fastqR/*

for zip in $nanoRfiles; do
	if [ ${zip: -3} == ".gz" ]; then
		printf "\nUnzipping"
		basename $zip
		gunzip $zip
	else
		basename $zip
		printf "We already unzipped these!\n\n"
	fi
done



# unzip full flow files
fullRfiles=./200221_Fei_fish_FullFlow_v5v6/cutadapt/fastqR/*

for zip in $fullRfiles; do
	if [ ${zip: -3} == ".gz" ]; then
		printf "\nUnzipping"
		basename $zip
		gunzip $zip
	else
		basename $zip
		printf "We already unzipped these!\n\n"
	fi
done



# append -full or -nano to headers
for nanoR in $nanoRfiles; do
	output=./results/fastqR/nano/new-$(basename $nanoR)
	if [ ! -e $output ]; then
		printf "\n\nChanging fastq headers\n"
		basename $nanoR
		sed '/@M0/ s/$/ nano/' $nanoR > ./results/fastqR/nano/new-$(basename $nanoR)
		printf "\n\n"
	else
		basename $nanoR
		printf "We already changed these!\n\n"
	fi
done


for fullR in $fullRfiles; do
	output=./results/fastqR/full/new-$(basename $fullR)
	if [ ! -e $output ]; then
		printf "\n\nChanging fastq headers\n"
		basename $fullR
		sed '/@M0/ s/$/ nano/' $fullR > ./results/fastqR/full/new-$(basename $fullR)
		printf "\n\n"
	else
		basename $output
		printf "We already changed these!\n\n"
	fi
done

newnanoRfiles=./results/fastqR/nano/new-*



# concatenate full and nano fastq files
for newnanoR in $newnanoRfiles; do
	output=./results/fastqR/cat-$(basename $newnanoR)
	if [ ! -e $output ]; then
		newfullR=${newnanoR/nano/full}
		printf "\nCombining\n"
		basename $newnanoR
		basename $newfullR
		cat $newnanoR $newfullR > ./results/fastqR/cat-$(basename $newnanoR)
		printf "\n\n"
	else
		basename $output
		printf "We already combined these!\n\n"
	fi
done
