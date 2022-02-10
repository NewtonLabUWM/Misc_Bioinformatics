# Sorting barcoded illumina reads into individual FASTQ files

The easy way to taxonomically identify microbial isolates!

## Background

<b>ISOLATES</b>

- Included are four samples: Multiplx1, Multiplx2, Multiplx3, Multiplx4.

- Each sample is a mix of 16 individual PCR reactions.

- Those reactions amplified the 16S rRNA v4 regions of microbial isolates.

- Therefore, in total, I selected 64 isolates for illumina sequencing.

<b>BARCODES</b>

- We appended short oligos to the 5' ends of our V4 primers.

- In this dataset, we had 4 forward primer barcodes and 4 reverse primer barcodes, allowing us to mix 16 reactions together.

<b>PROGRAM</b>

- This program reads your R1 & R2 files plus a metadata file that shows which barcodes are associated with which sample.

- Unzip/decompress your FASTQ files.

- Create a metadata file in excel and save as a .csv. In the first column list the sample names, the second column the forward barcode used for that sample, and the third column the reverse. For example -

```
lou$ head multiplx1.csv 
MULTIPLEX1_P10C1,CCTAACGGTCCA,TTCCTTAGTAGT
MULTIPLEX1_P10C3,CCTAACGGTCCA,CGTATAAATGCG
MULTIPLEX1_P12C2,TCCATACCGGAA,ACTCGCTCGCTG
MULTIPLEX1_P14C1,TCCATACCGGAA,TTCCTTAGTAGT
```



## Using the program

Use Python3

```
lou$ python --version
Python 3.8.6
```

Put contents of this GitHub in the same directory

```
lou$ ls
demultiplexFASTQ.py
Multiplx1_S91_L001_R1_001.fastq
Multiplx3_S93_L001_R1_001.fastq
multiplx1.csv
Multiplx1_S91_L001_R2_001.fastq
Multiplx3_S93_L001_R2_001.fastq
multiplx2.csv
Multiplx2_S92_L001_R1_001.fastq
Multiplx4_S94_L001_R1_001.fastq
multiplx3.csv
Multiplx2_S92_L001_R2_001.fastq
Multiplx4_S94_L001_R2_001.fastq
multiplx4.csv
```

Run it!

```
lou$ python3 demultiplexFASTQ.py
```

You will be asked for files...

```
= = = = = = = = = = = = =
SAMPLE DATA FORMAT (no headers)
	Comma separated (.csv)
	Column A: sample name
	Column B: forward barcode name
	Column C: reverse barcode name
= = = = = = = = = = = = =
Enter sample data file name: 
> 
```
```
= = = = = = = = = = = = =
FASTQ FILE FORMAT
	Unzipped (.fastq; not .fastq.gz, .fastq.bz2, etc)
= = = = = = = = = = = = =
Enter R1 file name: 
> 
```
```
= = = = = = = = = = = = =
Enter R2 file name: 
> 
```
