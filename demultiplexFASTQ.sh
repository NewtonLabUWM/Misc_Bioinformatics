#!/bin/sh -e

########################################
### trim fastq files using cutadapt,
### sort manually using grep & barcodes
### Lou LaMartina, started June 12 2019
########################################


# starting with 2 fastq files: one with forward reads,
# the other with reverse reads. each file contains mixed samples.
# samples were PCR'd with unique barcodes. this way, after sequencing, 
# we can use the barcodes to split them up into separate files. a total
# of 12 samples were mixed. since each have F and R reads, the end result
# is 24 fastq files, that will later be merged into contigs with dada2.

# with 4 GB memory, the first 5 steps take less than 1 minute. the last step,
# when reads are sorted into separate fastq files based on their header names,
# it takes about 10 mins for every 2000 seqs.

# to do: have it read-in a file with the oligo sequences,
# so don't have to add them to script each time.
# also loop at steps



########################
### 1. trim adapters ###
########################

adapterF="TCGTCGGCAGCGTCAGATGTGTATAAGAGACAG"
adapterR="GTCTCGTGGGCTCGGAGATGTGTATAAGAGACAG"


# forwards
for rawR1 in *_R1*; do
	cutadapt -m 100 -a $adapterF -o dedapted-$rawR1 $rawR1
	gzip -d dedapted-$rawR1
done


# reverses
for rawR2 in *_R2*; do
	cutadapt -m 100 -g $adapterR -o dedapted-$rawR2 $rawR2
	gzip -d dedapted-$rawR2
done




##############################
### 2. sort seqIDs by hand ###
##############################

Fbc01="^AGCCTTCGTCGC"
Fbc02="^TCCATACCGGAA"
Fbc03="^AGCCCTGCTACA"
Fbc04="^CCTAACGGTCCA"

Rbc01="^CGTATAAATGCG"
Rbc02="^ATGCTGCAACAC"
Rbc03="^ACTCGCTCGCTG"
Rbc04="^TTCCTTAGTAGT"

printf "\n\n\n\n. . . . sorting sequence IDs by barcode sequence . . . .\n\n\n\n"


# forwards w/out adapters
for dedaptedR1 in dedapted-*_R1*; do
	grep -B 1 $Fbc01 $dedaptedR1 | grep -e "@" | cut -d ' ' -f 1 > seqIDs-bc01-$dedaptedR1
	printf "\n"; grep -c $Fbc01 $dedaptedR1; printf "sequences with $Fbc01 in $dedaptedR1.\n\n"
done

for dedaptedR1 in dedapted-*_R1*; do
	grep -B 1 $Fbc02 $dedaptedR1 | grep -e "@" | cut -d ' ' -f 1 > seqIDs-bc02-$dedaptedR1
	printf "\n"; grep -c $Fbc02 $dedaptedR1; printf "sequences with $Fbc02 in $dedaptedR1.\n\n"
done

for dedaptedR1 in dedapted-*_R1*; do
	grep -B 1 $Fbc03 $dedaptedR1 | grep -e "@" | cut -d ' ' -f 1 > seqIDs-bc03-$dedaptedR1
	printf "\n"; grep -c $Fbc03 $dedaptedR1; printf "sequences with $Fbc03 in $dedaptedR1.\n\n"
done

for dedaptedR1 in dedapted-*_R1*; do
	grep -B 1 $Fbc04 $dedaptedR1 | grep -e "@" | cut -d ' ' -f 1 > seqIDs-bc04-$dedaptedR1
	printf "\n"; grep -c $Fbc04 $dedaptedR1; printf "sequences with $Fbc04 in $dedaptedR1.\n\n"
done


# reverses w/out adapters
for dedaptedR2 in dedapted-*_R2*; do
	grep -B 1 $Rbc01 $dedaptedR2 | grep -e "@" | cut -d ' ' -f 1 > seqIDs-bc01-$dedaptedR2
	printf "\n"; grep -c $Rbc01 $dedaptedR2; printf "sequences with $Rbc01 in $dedaptedR2.\n\n"
done

for dedaptedR2 in dedapted-*_R2*; do
	grep -B 1 $Rbc02 $dedaptedR2 | grep -e "@" | cut -d ' ' -f 1 > seqIDs-bc02-$dedaptedR2
	printf "\n"; grep -c $Rbc02 $dedaptedR2; printf "sequences with $Rbc02 in $dedaptedR2.\n\n"
done

for dedaptedR2 in dedapted-*_R2*; do
	grep -B 1 $Rbc03 $dedaptedR2 | grep -e "@" | cut -d ' ' -f 1 > seqIDs-bc03-$dedaptedR2
	printf "\n"; grep -c $Rbc03 $dedaptedR2; printf "sequences with $Rbc03 in $dedaptedR2.\n\n"
done

for dedaptedR2 in dedapted-*_R2*; do
	grep -B 1 $Rbc04 $dedaptedR2 | grep -e "@" | cut -d ' ' -f 1 > seqIDs-bc04-$dedaptedR2
	printf "\n"; grep -c $Rbc04 $dedaptedR2; printf "sequences with $Rbc04 in $dedaptedR2.\n\n"
done




############################
### 3. trim off barcodes ###
############################

printf "\n\n\n\n. . . . trimming barcodes . . . .\n\n\n\n"

# forwards w/out adapters
for dedaptedR1 in dedapted-*_R1*; do
	cutadapt -m 100 -g file:barcodes.fasta -o decoded-$dedaptedR1 $dedaptedR1
done

# reverses w/out adapters
for dedaptedR2 in dedapted-*_R2*; do
	cutadapt -m 100 -g file:barcodes.fasta -o decoded-$dedaptedR2 $dedaptedR2
done




##########################################
### 4. trim off pads, linkers, primers ###
##########################################

primerF="TATGGTAATTGTGTGYCAGCMGCCGCGGTAA"
primerR="AGTCAGCCAGCCGGACTACNVGGGTWTCTAAT"

printf "\n\n\n\n. . . . trimming primers . . . .\n\n\n\n"


# forwards w/out adapters or barcodes
for decodedR1 in decoded-*_R1*; do
	cutadapt -m 100 -g $primerF -o deprimed-$decodedR1 $decodedR1
done


# reverses w/out adapters or barcodes
for decodedR2 in decoded-*_R2*; do
	cutadapt -m 100 -g $primerR -o deprimed-$decodedR2 $decodedR2
done

# note: there are some that did not have barcodes removed because the barcodes
# were low quality/didn't match exact (had N's). that's ok - these will be kicked
# out when i sort seqs anyway, because those seq IDs wouldn't have shown up in
# the seq ID files in step 2




###################################
### 5. find shared sequence IDs ###
###################################

printf "\n\n\n\n. . . . finding shared sequence IDs . . . .\n\n\n\n"

seqIDs_Fbc01="seqIDs-bc01-dedapted-Multiplex-103-114_S47_L001_R1_001.fastq"
seqIDs_Fbc02="seqIDs-bc02-dedapted-Multiplex-103-114_S47_L001_R1_001.fastq"
seqIDs_Fbc03="seqIDs-bc03-dedapted-Multiplex-103-114_S47_L001_R1_001.fastq"
seqIDs_Fbc04="seqIDs-bc04-dedapted-Multiplex-103-114_S47_L001_R1_001.fastq"

seqIDs_Rbc01="seqIDs-bc01-dedapted-Multiplex-103-114_S47_L001_R2_001.fastq"
seqIDs_Rbc02="seqIDs-bc02-dedapted-Multiplex-103-114_S47_L001_R2_001.fastq"
seqIDs_Rbc03="seqIDs-bc03-dedapted-Multiplex-103-114_S47_L001_R2_001.fastq"
seqIDs_Rbc04="seqIDs-bc04-dedapted-Multiplex-103-114_S47_L001_R2_001.fastq"

fastq1="KA103"
fastq2="KA104"
fastq3="KA105"
fastq4="KA106"

fastq5="KA107"
fastq6="KA108"
fastq7="KA109"
fastq8="KA110"

fastq9="KA111"
fastq10="KA112"
fastq11="KA113"
fastq12="KA114"


## fastq1
# Fbc01, Rbc01
awk 'FNR==NR{a[$1];next}($1 in a){print}' $seqIDs_Fbc01 $seqIDs_Rbc01 > seqIDs_$fastq1.txt
grep -c "@" $seqIDs_Fbc01; printf "sequences in $seqIDs_Fbc01\n"
grep -c "@" $seqIDs_Rbc01; printf "sequences in $seqIDs_Rbc01\n"
grep -c "@" seqIDs_$fastq1.txt; printf "sequences in $fastq1\n\n"


### fastq2
# Fbc01, Rbc02
awk 'FNR==NR{a[$1];next}($1 in a){print}' $seqIDs_Fbc01 $seqIDs_Rbc02 > seqIDs_$fastq2.txt
grep -c "@" $seqIDs_Fbc01; printf "sequences in $seqIDs_Fbc01\n"
grep -c "@" $seqIDs_Rbc02; printf "sequences in $seqIDs_Rbc02\n"
grep -c "@" seqIDs_$fastq2.txt; printf "sequences in $fastq2\n\n"
 

### fastq3
# Fbc01, Rbc03
awk 'FNR==NR{a[$1];next}($1 in a){print}' $seqIDs_Fbc01 $seqIDs_Rbc03 > seqIDs_$fastq3.txt
grep -c "@" $seqIDs_Fbc01; printf "sequences in $seqIDs_Fbc01\n"
grep -c "@" $seqIDs_Rbc03; printf "sequences in $seqIDs_Rbc03\n"
grep -c "@" seqIDs_$fastq3.txt; printf "sequences in $fastq3\n\n"


### fastq4
# Fbc01, Rbc04
awk 'FNR==NR{a[$1];next}($1 in a){print}' $seqIDs_Fbc01 $seqIDs_Rbc04 > seqIDs_$fastq4.txt
grep -c "@" $seqIDs_Fbc01; printf "sequences in $seqIDs_Fbc01\n"
grep -c "@" $seqIDs_Rbc04; printf "sequences in $seqIDs_Rbc04\n"
grep -c "@" seqIDs_$fastq4.txt; printf "sequences in $fastq4\n\n"


### fastq5
# Fbc02, Rbc01
awk 'FNR==NR{a[$1];next}($1 in a){print}' $seqIDs_Fbc02 $seqIDs_Rbc01 > seqIDs_$fastq5.txt
grep -c "@" $seqIDs_Fbc02; printf "sequences in $seqIDs_Fbc02\n"
grep -c "@" $seqIDs_Rbc01; printf "sequences in $seqIDFbcs_Rbc01\n"
grep -c "@" seqIDs_$fastq5.txt; printf "sequences in $fastq5\n\n"


### fastq6
# Fbc02, Rbc02
awk 'FNR==NR{a[$1];next}($1 in a){print}' $seqIDs_Fbc02 $seqIDs_Rbc02 > seqIDs_$fastq6.txt
grep -c "@" $seqIDs_Fbc02; printf "sequences in $seqIDs_Fbc02\n"
grep -c "@" $seqIDs_Rbc02; printf "sequences in $seqIDs_Rbc02\n"
grep -c "@" seqIDs_$fastq6.txt; printf "sequences in $fastq6\n\n"


### fastq7
# Fbc02, Rbc04
awk 'FNR==NR{a[$1];next}($1 in a){print}' $seqIDs_Fbc02 $seqIDs_Rbc04 > seqIDs_$fastq7.txt
grep -c "@" $seqIDs_Fbc02; printf "sequences in $seqIDs_Fbc02\n"
grep -c "@" $seqIDs_Rbc04; printf "sequences in $seqIDs_Rbc04\n"
grep -c "@" seqIDs_$fastq7.txt; printf "sequences in $fastq7\n\n"


### fastq8
# Fbc02, Rbc03
awk 'FNR==NR{a[$1];next}($1 in a){print}' $seqIDs_Fbc02 $seqIDs_Rbc03 > seqIDs_$fastq8.txt
grep -c "@" $seqIDs_Fbc02; printf "sequences in $seqIDs_Fbc02\n"
grep -c "@" $seqIDs_Rbc03; printf "sequences in $seqIDs_Rbc03\n"
grep -c "@" seqIDs_$fastq8.txt; printf "sequences in $fastq8\n\n"


### fastq9
# Fbc03, Rbc01
awk 'FNR==NR{a[$1];next}($1 in a){print}' $seqIDs_Fbc03 $seqIDs_Rbc01 > seqIDs_$fastq9.txt
grep -c "@" $seqIDs_Fbc03; printf "sequences in $seqIDs_Fbc03\n"
grep -c "@" $seqIDs_Rbc01; printf "sequences in $seqIDs_Rbc01\n"
grep -c "@" seqIDs_$fastq9.txt; printf "sequences in $fastq9\n\n"


### fastq10
# Fbc03, Rbc02
awk 'FNR==NR{a[$1];next}($1 in a){print}' $seqIDs_Fbc03 $seqIDs_Rbc02 > seqIDs_$fastq10.txt
grep -c "@" $seqIDs_Fbc03; printf "sequences in $seqIDs_Fbc03\n"
grep -c "@" $seqIDs_Rbc02; printf "sequences in $seqIDs_Rbc02\n"
grep -c "@" seqIDs_$fastq10.txt; printf "sequences in $fastq10\n\n"


### fastq11
# Fbc03, Rbc03
awk 'FNR==NR{a[$1];next}($1 in a){print}' $seqIDs_Fbc03 $seqIDs_Rbc03 > seqIDs_$fastq11.txt
grep -c "@" $seqIDs_Fbc03; printf "sequences in $seqIDs_Fbc03\n"
grep -c "@" $seqIDs_Rbc03; printf "sequences in $seqIDs_Rbc03\n"
grep -c "@" seqIDs_$fastq11.txt; printf "sequences in $fastq11\n\n"


### fastq12
# Fbc03, Rbc04
awk 'FNR==NR{a[$1];next}($1 in a){print}' $seqIDs_Fbc03 $seqIDs_Rbc04 > seqIDs_$fastq12.txt
grep -c "@" $seqIDs_Fbc03; printf "sequences in $seqIDs_Fbc03\n"
grep -c "@" $seqIDs_Rbc04; printf "sequences in $seqIDs_Rbc04\n"
grep -c "@" seqIDs_$fastq12.txt; printf "sequences in $fastq12\n\n"




##################################
### 5. sort reads into samples ###
##################################

printf "\n\n\n\n. . . . sorting into samples . . . .\n\n\n\n"
printf "\n\n\n\n. . . . this takes a while! . . . .\n\n\n\n"

header_file_fastq1="seqIDs_$fastq1.txt"
header_file_fastq2="seqIDs_$fastq2.txt"
header_file_fastq3="seqIDs_$fastq3.txt"

header_file_fastq4="seqIDs_$fastq4.txt"
header_file_fastq5="seqIDs_$fastq5.txt"
header_file_fastq6="seqIDs_$fastq6.txt"

header_file_fastq7="seqIDs_$fastq7.txt"
header_file_fastq8="seqIDs_$fastq8.txt"
header_file_fastq9="seqIDs_$fastq9.txt"

header_file_fastq10="seqIDs_$fastq10.txt"
header_file_fastq11="seqIDs_$fastq11.txt"
header_file_fastq12="seqIDs_$fastq12.txt"



############
### FORWARDS

# fastq1
printf "\n\nsorting $fastq1 . . .\n\n"
while IFS= read -r headers; do
	grep -A 3 $headers deprimed-*_R1* 
done < $header_file_fastq1 >> R1_$fastq1.fastq


# fastq2
printf "\n\nsorting $fastq2 . . ."
while IFS= read -r headers; do
	grep -A 3 $headers deprimed-*_R1* 
done < $header_file_fastq2 >> R1_$fastq2.fastq


# fastq3
printf "\n\nsorting $fastq3 . . ."
while IFS= read -r headers; do
	grep -A 3 $headers deprimed-*_R1* 
done < $header_file_fastq3 >> R1_$fastq3.fastq


# fastq4
printf "\n\nsorting $fastq4 . . ."
while IFS= read -r headers; do
	grep -A 3 $headers deprimed-*_R1* 
done < $header_file_fastq4 >> R1_$fastq4.fastq


# fastq5
printf "\n\nsorting $fastq5 . . ."
while IFS= read -r headers; do
	grep -A 3 $headers deprimed-*_R1* 
done < $header_file_fastq5 >> R1_$fastq5.fastq


# fastq6
printf "\n\nsorting $fastq6 . . ."
while IFS= read -r headers; do
	grep -A 3 $headers deprimed-*_R1* 
done < $header_file_fastq6 >> R1_$fastq6.fastq


# fastq7
printf "\n\nsorting $fastq7 . . ."
while IFS= read -r headers; do
	grep -A 3 $headers deprimed-*_R1* 
done < $header_file_fastq7 >> R1_$fastq7.fastq


# fastq8
printf "\n\nsorting $fastq8 . . ."
while IFS= read -r headers; do
	grep -A 3 $headers deprimed-*_R1* 
done < $header_file_fastq8 >> R1_$fastq8.fastq


# fastq9
printf "\n\nsorting $fastq9 . . ."
while IFS= read -r headers; do
	grep -A 3 $headers deprimed-*_R1* 
done < $header_file_fastq9 >> R1_$fastq9.fastq


# fastq10
printf "\n\nsorting $fastq10 . . ."
while IFS= read -r headers; do
	grep -A 3 $headers deprimed-*_R1* 
done < $header_file_fastq10 >> R1_$fastq10.fastq


# fastq11
printf "\n\nsorting $fastq11 . . ."
while IFS= read -r headers; do
	grep -A 3 $headers deprimed-*_R1* 
done < $header_file_fastq11 >> R1_$fastq11.fastq


# fastq12
printf "\n\nsorting $fastq12 . . ."
while IFS= read -r headers; do
	grep -A 3 $headers deprimed-*_R1* 
done < $header_file_fastq12 >> R1_$fastq12.fastq



############
### REVERSES

# fastq1
printf "\n\nsorting $fastq1 . . ."
while IFS= read -r headers; do
	grep -A 3 $headers deprimed-*_R2* 
done < $header_file_fastq1 >> R2_$fastq1.fastq


# fastq2
printf "\n\nsorting $fastq2 . . ."
while IFS= read -r headers; do
	grep -A 3 $headers deprimed-*_R2* 
done < $header_file_fastq2 >> R2_$fastq2.fastq


# fastq3
printf "\n\nsorting $fastq3 . . ."
while IFS= read -r headers; do
	grep -A 3 $headers deprimed-*_R2* 
done < $header_file_fastq3 >> R2_$fastq3.fastq


# fastq4
printf "\n\nsorting $fastq4 . . ."
while IFS= read -r headers; do
	grep -A 3 $headers deprimed-*_R2* 
done < $header_file_fastq4 >> R2_$fastq4.fastq


# fastq5
printf "\n\nsorting $fastq5 . . ."
while IFS= read -r headers; do
	grep -A 3 $headers deprimed-*_R2* 
done < $header_file_fastq5 >> R2_$fastq5.fastq


# fastq6
printf "\n\nsorting $fastq6 . . ."
while IFS= read -r headers; do
	grep -A 3 $headers deprimed-*_R2* 
done < $header_file_fastq6 >> R2_$fastq6.fastq


# fastq7
printf "\n\nsorting $fastq7 . . ."
while IFS= read -r headers; do
	grep -A 3 $headers deprimed-*_R2* 
done < $header_file_fastq7 >> R2_$fastq7.fastq


# fastq8
printf "\n\nsorting $fastq8 . . ."
while IFS= read -r headers; do
	grep -A 3 $headers deprimed-*_R2* 
done < $header_file_fastq8 >> R2_$fastq8.fastq


# fastq9
printf "\n\nsorting $fastq9 . . ."
while IFS= read -r headers; do
	grep -A 3 $headers deprimed-*_R2* 
done < $header_file_fastq9 >> R2_$fastq9.fastq


# fastq10
printf "\n\nsorting $fastq10 . . ."
while IFS= read -r headers; do
	grep -A 3 $headers deprimed-*_R2* 
done < $header_file_fastq10 >> R2_$fastq10.fastq


# fastq11
printf "\n\nsorting $fastq11 . . ."
while IFS= read -r headers; do
	grep -A 3 $headers deprimed-*_R2* 
done < $header_file_fastq11 >> R2_$fastq11.fastq


# fastq12
printf "\n\nsorting $fastq12 . . ."
while IFS= read -r headers; do
	grep -A 3 $headers deprimed-*_R2* 
done < $header_file_fastq12 >> R2_$fastq12.fastq
