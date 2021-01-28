# Trimming primers from 16S rRNA gene sequences

## Check Python version

```
lou$ python --version
Python 3.8.6
```

Cutadapt [requires](https://cutadapt.readthedocs.io/en/stable/installation.html#dependencies) Python 3.6 or new. 


## Install Miniconda

Because it makes life [easier](https://bioconda.github.io/user/install.html).


## Install Cutadapt

Creating a [virtual environment](https://cutadapt.readthedocs.io/en/stable/installation.html) allows Cutadapt to access the Python versions and packages it depends on.

```
lou$ conda activate cutadaptenv
(cutadaptenv) lou$ 
(cutadaptenv) lou$ cutadapt --version
3.2
```
You can see the venv is activated when its name is at the beginning of the prompt.

Without the venv, Cutadapt commands will not work.

```
lou$ cutadapt --version
-bash: cutadapt: command not found
```




## Organize files
The following files should be in the same directory:
- FASTQ files
- cutadapt script
- FASTA with primer sequences (V4-V5 only)


## Execute script
1. Go to the directory described above

```
(cutadaptenv) lou$ cd ~/path/to/FASTQs
```

2. Execute cutadapt script

```
(cutadaptenv) lou$ sh cutadapt_script.sh
```

The [parameters](https://cutadapt.readthedocs.io/en/stable/guide.html) we typically choose are:

| Flag | Description |
| ---| --- |
| -g | regular 5' primer |
| -G | corresponding reverse file |
| -m | set minimum length \* |
| -o | location & name of output forward file |
| -p | location & name of output reverse file |

\* if this isn't set, you can end up with "empty" reads, that have a header but no sequence. This will complicate processing later.

## Interpret output

The output text file will look something like this:

```
This is cutadapt 3.2 with Python 3.8.6
Command line parameters: -g CCAGCAGCYGCGGTAAN -G file:v4v5_revs.fasta -o cutadapt/SRR11487869_pass_1.fastq.gz -p cutadapt/SRR11487869_pass_2.fastq.gz SRR11487869_pass_1.fastq.gz SRR11487869_pass_2.fastq.gz
Processing reads on 1 core in paired-end mode ...
Finished in 10.70 s (81 µs/read; 0.74 M reads/minute).

=== Summary ===

Total read pairs processed:            132,777
  Read 1 with adapter:                 130,937 (98.6%)
  Read 2 with adapter:                 129,971 (97.9%)
Pairs written (passing filters):       132,777 (100.0%)

Total basepairs processed:    66,574,524 bp
  Read 1:    33,303,745 bp
  Read 2:    33,270,779 bp
Total written (filtered):     61,962,009 bp (93.1%)
  Read 1:    31,078,014 bp
  Read 2:    30,883,995 bp

=== First read: Adapter 1 ===

Sequence: CCAGCAGCYGCGGTAAN; Type: regular 5'; Length: 17; Trimmed: 130937 times

No. of allowed errors:
1-9 bp: 0; 10-16 bp: 1

Overview of removed sequences
length	count	expect	max.err	error counts
3	3	2074.6	0	3
11	2	0.0	1	0 2


etc...
```

Which shows that the forward primer was trimmed from 130,937 reads, out of 132,777 total reads in this file.


These files can be processed using [DADA2](https://benjjneb.github.io/dada2/tutorial.html)!
