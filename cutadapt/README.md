## Install Cutadapt

[Conda install](https://anaconda.org/bioconda/cutadapt)

`conda install -c bioconda cutadapt`


## Organize files
The following files should be in the same directory:
- FASTQ files
- cutadapt script
- FASTA with primer sequence (V4-V5 only)


## Execute script
1. Go to directory where your FASTQ files are stored

  `cd ~/path/to/directory`

2. Execute cutadapt script

`sh cutadapt_script.sh`
