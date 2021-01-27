# Trimming primer sequences from 16S rRNA gene sequences

## Check Python version

```
lou$ python --version
Python 3.8.6
```

Cutadapt [requires](https://cutadapt.readthedocs.io/en/stable/installation.html#dependencies) Python 3.6 or new. 


## Install Miniconda

Because [conda](https://bioconda.github.io/user/install.html) makes life easier.


## Install Cutadapt

Creating a [virtual environment](https://cutadapt.readthedocs.io/en/stable/installation.html) allows Cutadapt to access the Python versions and packages it depends on.

```
lou$ conda activate cutadaptenv
(cutadaptenv) lou$ 
(cutadaptenv) lou$ cutadapt --version
3.2
```
You can see the venv is activated when it is at the beginning of the new line.

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
1. Go to directory where your FASTQ files are stored

`(cutadaptenv) lou$ cd ~/path/to/directory`

2. Execute cutadapt script

`(cutadaptenv) lou$ sh cutadapt_script.sh`
