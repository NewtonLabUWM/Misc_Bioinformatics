##########################################
### count total number of bases in FASTA,
### convert to reads per kilobase million,
### save to CSV
### Lou LaMartina, started May 6 2021
##########################################



import os
import csv




### get lengths of each read


lengths = {}
fastas = tuple(['.fa', '.fna', '.fasta', '.fs'])


for file in os.listdir():

    # find fasta files
    if file.endswith(fastas):

        # open fasta files
        with open(file, 'r') as ifile:           
            lengths[file] = []           
            for line in ifile:              
                if line.startswith('>'):

                    # get lengths of reads (line after >header)
                    lengths[file].append(len(next(ifile, '')))





### sum read lengths
                    

sums = {}

for k, v in lengths.items():
    
    # keys = file name, values = sum of read lengths
    sums.update({k:sum(v)}) 





### save to CSV


# name new file
with open('baseCounts.csv', 'w', newline = '') as csvfile:

    # name columns
    headers = ['File', 'numBases']

    # convert dictionary to CSV
    writer = csv.DictWriter(csvfile, fieldnames = headers) 
    writer.writeheader()   
    for key in sums:  
        writer.writerow({'File': key, 'numBases': sums[key]})
