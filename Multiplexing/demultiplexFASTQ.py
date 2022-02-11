########################################################
### demultiplexing fastq files based on unique barcodes,
### representing individual microbial isolates
### Lou LaMartina, updated Feb 11, 2022
########################################################


import csv
import numpy as np

np.warnings.filterwarnings('ignore', category = np.VisibleDeprecationWarning)


####################
### prompt files ###
####################

# sample barcode mapping
sampleFile = input(
    "\n\n= = = = = = = = = = = = =\n"\
    "SAMPLE DATA FORMAT (no headers)\n\n"\
    "\tComma separated (.csv)\n"\
    "\tColumn A: sample name\n"\
    "\tColumn B: forward barcode name\n"\
    "\tColumn C: reverse barcode name\n\n"\
    "=== Enter sample data file name: > ")


# barcoded illumina reads
R1file = input(
    "\n\n= = = = = = = = = = = = =\n"\
    "FASTQ FILE FORMAT\n"\
    "\tUnzipped (.fastq; not .fastq.gz, .fastq.bz2, etc)"\
    "\n\n=== Enter R1 file name: > ")

R2file = input("\n=== Enter R2 file name: > ")




######################
### dissect fastqs ###
######################

# END GOAL = { ids : [ reads : scores ], ... }


### forwards ###

idsF = []
readsF = []
scoresF = []
count = 0

with open(R1file, 'r') as fileF:
    print("\n")

    for line in fileF:

        if line.startswith('@'):

            # track progress - helpful for large files!    
            count += 1
            if count % 10000 == 0:
                pct = "{:.0f}".format(count / open(R1file, 'r').read().count("@M") * 100)
                print("\tStripped", count, "forward reads (", pct, "% complete )")
            
            # strip sequence IDs
            idsF.append(line.strip())

            # remove strings after white space in headers
            # (need sequence IDs to be identical for F and R,
            # which they are before this space)
            idsF = [i.split(' ', 1)[0] for i in idsF]
            
        if line.startswith('@'):
            
            # strip sequence reads
            readsF.append(next(fileF, '').strip())

        if line.startswith('+'):
            
            # strip quality scores
            scoresF.append(next(fileF, '').strip())


# store in dictionary { ids : [ reads : scores ] }
R1Dict = { x : [ y, z, x ] for x, y, z in zip(idsF, readsF, scoresF) }



### reverses ###

idsR = []
readsR = []
scoresR = []
count = 0

with open(R2file, 'r') as fileR:
    print("\n")

    for line in fileR:

        if line.startswith('@'):

            # track progress - helpful for large files!    
            count += 1
            if count % 10000 == 0:
                pct = "{:.0f}".format(count / open(R2file, 'r').read().count("@M") * 100)
                print("\tStripped", count, "reverse reads (", pct, "% complete )")
            
            # strip sequence IDs
            idsR.append(line.strip())

            # remove strings after white space in headers
            # (need sequence IDs to be identical for F and R,
            # which they are before this space)
            idsR = [i.split(' ', 1)[0] for i in idsR]
            
        if line.startswith('@'):
            
            # strip sequence reads
            readsR.append(next(fileR, '').strip())

        if line.startswith('+'):
            
            # strip quality scores
            scoresR.append(next(fileR, '').strip())


# store in dictionary { ids : [ reads : scores ] }
R2Dict = { x : [ y, z, x ] for x, y, z in zip(idsR, readsR, scoresR) }




#######################
### dissect samples ###
#######################

# END GOAL { sample : barcode, ... } 


# open file
with open(sampleFile, encoding = 'utf-8-sig') as f:
    reader = csv.reader(f)
    sampleData = list(reader)


# create dictionary { sample : barcode } 
sampleDict = { item[0] : item[1:] for item in sampleData }


# define column with F barcodes
def codeF(smps):
    return [item[0] for item in smps]


# define column with R barcodes
def codeR(smps):
    return [item[1] for item in smps]

    
# verbose
print("\n\n\t= = = Read", len(sampleDict), "samples = = = \n\n")




######################
### match barcodes ###
######################

# END GOAL = { barcode : [ read, scores, id ], ... }


### forwards ###

uniqueFs = list(np.unique(codeF(list(sampleDict.values()))))
matchFs = []

# bc is unique barcode
for bc in uniqueFs:

    # organizes dictionary to those that match the barcode
    Fs = list(filter(lambda a : bc in a[0], R1Dict.values()))

    # make list of matches
    matchFs.append(Fs)



### reverses ###

uniqueRs = list(np.unique(codeR(list(sampleDict.values()))))
matchRs = []

for bc in uniqueRs:
    Rs = list(filter(lambda a : bc in a[0], R2Dict.values()))
    matchRs.append(Rs)


# create dictionary { barcode : [ read, scores, id ] }
matchFDict = { uniqueFs[bc] : matchFs[bc] for bc in range(len(uniqueFs)) }
matchRDict = { uniqueRs[bc] : matchRs[bc] for bc in range(len(uniqueRs)) }


# verbose
print("\t= = = Forward barcodes = = =")
for i in range(len(matchFs)):
    print("\t\t", uniqueFs[i], "matched", len(matchFs[i]), "times")

print("\t= = = Reverse barcodes = = =")
for i in range(len(matchRs)):
    print("\t\t", uniqueRs[i], "matched", len(matchRs[i]), "times")




#####################
### match samples ###
#####################

# END GOAL = { sample : [[ read, scores, id ], [ read, scores, id ], ... ] }


### forwards ###

matchFSmps = []

# smp is individual samples
for smp in sampleDict:

    # bc is barcodes
    for bc in uniqueFs:

        # find that barcode in that sample
        if bc in sampleDict[smp]:

            # extract read, score of that match
            smps = matchFDict[bc]

            # save to list
            matchFSmps.append(smps)


###  reverses ###

matchRSmps = []

# smp is individual samples
for smp in sampleDict:

    # bc is barcodes
    for bc in uniqueRs:

        # find that barcode in that sample
        if bc in sampleDict[smp]:

            # extract read, score of that match
            smps = matchRDict[bc]

            # save to list
            matchRSmps.append(smps)


# create dictionary { sample : [[ read, scores, id ], [ read, scores, id ] ... ] }
matchRSmpsDict = { list(sampleDict.keys())[s] : matchRSmps[s] for s in range(len(sampleDict)) }
matchFSmpsDict = { list(sampleDict.keys())[s] : matchFSmps[s] for s in range(len(sampleDict)) }


# convert to matrix
sampleNames = list(sampleDict.keys())
matrixR = np.array([matchRSmpsDict[i] for i in sampleNames])
matrixF = np.array([matchFSmpsDict[i] for i in sampleNames])


# extract columns from matrix
def column(matrix, i):
    return [row[i] for row in matrix]




##########################
### match sequence IDs ###
##########################

# END GOAL = { sample : [ @seq, @seq, @seq ], ... }


seqsToSmps = []

# in each sample
for i in range(len(sampleNames)):

        # for sequence IDs shared in F and R
        if set(column(matrixF[i], 2)) & set(column(matrixR[i], 2)):

            # create list of shared IDs for each sample
            seqs = list(set(column(matrixF[i], 2)) & set(column(matrixR[i], 2)))
            seqsToSmps.append(seqs)
        
        elif set(column(matrixF[i], 2)) | set(column(matrixR[i], 2)):
            print("\n\n\t= = =", sampleNames[i], "\t: NO MATCHES = = =")
            sampleNames.remove(sampleNames[i])





# create dictionary { sample : [ @seq, @seq, @seq ] }
seqsToSmpsDict = { sampleNames[i] : seqsToSmps[i] for i in range(len(sampleNames)) }



# verbose
print("\n\n\t= = = Number of matches = = =")
for i in range(len(sampleNames)):
    print("\t\t", list(seqsToSmpsDict.keys())[i], "\t:", len(list(seqsToSmpsDict.values())[i]), "reads")




############################
### match reads & scores ###
############################

# END GOAL = { sample : [ [ @seq, scores, read ], [ @seq, scores, read ] ... ] }


### forwards ###

mappedF = {}

for i in range(len(sampleNames)):

    # give each sample (dictionary key) an empty list (to fill with seqs & seq info)
    mappedF.setdefault(sampleNames[i], [])

    # j is range of # of seqs in that sample
    for j in range(len(list(seqsToSmpsDict.values())[i])):

        # k is a specific seq
        k = list(seqsToSmpsDict.values())[i][j]

        # l is that specific seq, a key in the dict, whose values are seq info
        l = list(R1Dict[k])

        # appending that seq info to the proper position in our new dict
        mappedF[sampleNames[i]].append(l)



### reverses ###

mappedR = {}

for i in range(len(sampleNames)):

    # give each sample (dictionary key) and empty list (to fill with seqs & seq info)
    mappedR.setdefault(sampleNames[i], [])

    # j is range of # of seqs in that sample
    for j in range(len(list(seqsToSmpsDict.values())[i])):

        # k is a specific seq
        k = list(seqsToSmpsDict.values())[i][j]

        # l is that specific seq, a key in the dict, whose values are seq info
        l = list(R2Dict[k])

        # appending that seq info to the proper position in our new dict
        mappedR[sampleNames[i]].append(l)


# convert to matrices
matrixMappedF = np.array([mappedF[i] for i in sampleNames])
matrixMappedR = np.array([mappedR[i] for i in sampleNames])




##########################
### save as new fastqs ###
##########################

# R1 files
for i in range(len(sampleNames)):
    with open("{}_R1.fastq".format(sampleNames[i]), "w") as finalF:
    
        for j in range(len(matrixMappedF[i])):
            finalF.write("%s\r\n" % column(matrixMappedF[i], 2)[j])
            finalF.write("%s\r\n" % column(matrixMappedF[i], 0)[j])
            finalF.write("+\r\n")
            finalF.write("%s\r\n" % column(matrixMappedF[i], 1)[j])
  
finalF.close()


# R2 files
for i in range(len(sampleNames)):
    with open("{}_R2.fastq".format(sampleNames[i]), "w") as finalR:
    
        for j in range(len(matrixMappedR[i])):
            finalR.write("%s\r\n" % column(matrixMappedR[i], 2)[j])
            finalR.write("%s\r\n" % column(matrixMappedR[i], 0)[j])
            finalR.write("+\r\n")
            finalR.write("%s\r\n" % column(matrixMappedR[i], 1)[j])

finalR.close()


# verbose
def sum_list(l):
    sum = 0
    for x in l:
        sum += x
    return sum

nreads = []
for i in range(len(sampleNames)):
    nread = len(list(seqsToSmpsDict.values())[i])
    nreads.append(nread)

print("\n\n\n\t= = = %i unique reads sorted into %i R1 and R2 files = = =\n\n" %
      (sum_list(nreads), len(sampleDict)))
