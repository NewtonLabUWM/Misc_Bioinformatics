# Miscellaneous bioinformatics

Navigating common challenges in microbial ecology.


## Multiplexing
<b>Protocol.</b> How to sort barcoded illumina reads into individual FASTQ files... The easy way to taxonomically identify microbial isolates! Includes a program (demultiplexFASTQ.py) and a four-sample dataset.


## exactMatching
<b>Protocol.</b> We commonly want to find exact matches between sequences in two FASTA files. When files are large, we don't always need or want the robust BLAST algorithm. This is a perl program that is fast, light, and easy.


## Cutadapt
<b>Protocol. </b>How to trim primer sequences from reads generated by Illumina. Plus several common targets:
1. microbial V3-V4 16S rRNA
2. microbial V4 16S rRNA
3. bacterial V4-V5 16S rRNA
4. microbial V1-V9 16S rRNA
5. microbial V1-ITS 16S rRNA
6. fungal 18S rRNA


## DADA2
1. <b>filterAndTrim_bigData.R.</b> At the filterAndTrim step, process groups of samples one at a time instead of all samples simultaneously. Saves time and computer power and crashes and headaches.

2. <b>merge_ASV_tables.R.</b> Helpful when you have many ASV tables from DADA2 and want to merge them by unique FASTA sequences.


## NCBI
1. <b>removeLineBreakFASTA.sh.</b> Downloading contigs from NCBI, there are line breaks at 800bp. Remove those with this.

2. <b>downloadMultipleSRA_series.sh.</b> Download multiple files from Sequence Read Archive. Use when you're interested in runs that are named as a series of numbers, which is typical for BioProjects (e.g., runs in project PRJNA597057 range from SRR10755563 to SRR10755886).

3. <b>downloadMultipleSRA_text.sh.</b> Download multiple files from Sequence Read Archive. Use when you're interested in runs that are not named in a series. Create a text file called "runs.txt" with all desired runs.


## navigateFASTQ-A
1. <b>catFASTQ.sh.</b> Concatenate FASTQ files with identical names. Its original purpose was to combine files from two sequencing runs (on full and nano Illumina flow cells) on the same samples. 

2. <b>calculateRPKM.py.</b> Count number of bases in FASTA and convert to reads per kilobase million (rpkm). Metric used in metatrascriptomics.

3. <b>subsetFASTQ.sh.</b> Subset a large FASTQ into smaller ones. Was helpful when learning error rates on a large dataset in dada2.

4. <b>fastaToCSV.sh.</b> Have a FASTA file? Want to work with it in Excel or R? Use this. The result is a spreadsheet with two columns, "Headers" and "FASTA."


## toolsAndPipelines
1. <b>rgiFASTA.sh.</b> Mine ARGs from FASTAs in a directory with CARD's resistance gene identifier.

2. <b>deepARG_organize.R.</b> Load and organize results from the deepARG online tool. 

3. <b>metaxa2_([fastq or fasta].sh.</b> Assess taxonomy in assembled or unassembled metagenomes with Metaxa2.

4. <b>integronFinder.sh.</b> Mine integron sequences from contigs with Integron Finder.

5. <b>mobileOG-db.sh.</b> Mine mobile genetic elements from the mobileOG database.
