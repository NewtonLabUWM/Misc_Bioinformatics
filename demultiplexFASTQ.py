########################################################
### demultiplexing fastq files based on unique barcodes.
### nexteras already trimmed? files decompressed.
### Lou LaMartina, started April 12, 2021
########################################################


import csv
import numpy as np



##############
### prompt ###
##############



# sample barcode mapping
sampleFile = input(
    "\n\n= = = = = = = = = = = = =\n\n"\
    "SAMPLE DATA FORMAT\n\n"\
    "\tComma separated (.csv)\n\n"\
    "\tColumn A: sample name\n\n"\
    "\tColumn B: forward barcode name\n\n"\
    "\tColumn C: reverse barcode name\n\n"\
    "= = = = = = = = = = = = =\n\nEnter sample data file name: \n\n> ")



# barcoded illumina reads
R1File = input(
    "\n\n= = = = = = = = = = = = =\n\n"\
    "FASTQ FILE FORMAT\n\n"\
    "\tUnzipped (.fastq; not .fastq.gz, .fastq.bz2, etc)"\
    "\n\n= = = = = = = = = = = = =\n\nEnter R1 file name: \n\n> ")

R2File = input("\n\n= = = = = = = = = = = = =\n\nEnter R2 file name: \n\n> ")








### fastq


# strip IDs, reads, and scores from FASTQ

ids = []
reads = []
scores = []

with open(R1File, 'r') as ifile:

    for line in ifile:
        if line.startswith('@'):
            
            # strip sequence IDs
            ids.append(line.strip())
            
        if line.startswith('@'):
            
            # strip sequence reads
            reads.append(next(ifile, '').strip())

        if line.startswith('+'):
            
            # strip quality scores
            scores.append(next(
                ifile, '').strip())



# store in dictionary { ids : [ reads : scores ] }
R1Dict = { x : [ y, z, x ] for x, y, z in zip(ids, reads, scores) }



with open(R2File, 'r') as ifile:

    for line in ifile:
        if line.startswith('@'):
            
            # strip sequence IDs
            ids.append(line.strip())
            
        if line.startswith('@'):
            
            # strip sequence reads
            reads.append(next(ifile, '').strip())

        if line.startswith('+'):
            
            # strip quality scores
            scores.append(next(
                ifile, '').strip())



# store in dictionary { ids : [ reads : scores ] }
R2Dict = { x : [ y, z, x ] for x, y, z in zip(ids, reads, scores) }






### samples


# open file
with open(sampleFile, encoding = 'utf-8-sig') as f:
    reader = csv.reader(f)
    sampleData = list(reader)


# create dictionary { sample : barcode } 
sampleDict = { item[0] : item[1:] for item in sampleData }

    
    





######################
### match barcodes ###
######################




### extract barcodes from sample data

# forwards
def codeF(smps):
    return [item[0] for item in smps]


# reverses
def codeR(smps):
    return [item[1] for item in smps]






### match barcodes to fastq reads


# forwards
uniqueFs = list(np.unique(codeF(list(sampleDict.values()))))
matchFs = []

for f in uniqueFs:
    Fs = list(filter(lambda a : f in a[0], R1Dict.values()))
    matchFs.append(Fs)




# reverses
uniqueRs = list(np.unique(codeR(list(sampleDict.values()))))
matchRs = []

for r in uniqueRs:
    Rs = list(filter(lambda a : r in a[0], R2Dict.values()))
    matchRs.append(Rs)



# create dictionaries { barcode : [ read, scores, id ] }
matchFDict = { uniqueFs[f] : matchFs[f] for f in range(len(uniqueFs)) }
matchRDict = { uniqueRs[r] : matchRs[r] for r in range(len(uniqueRs)) }



# match
matchFSmps = []

for s in sampleDict:
    for f in uniqueFs:
        if f in sampleDict[s]:
            smps = matchFDict[f]
            matchFSmps.append(smps)

matchRSmps = []

for s in sampleDict:
    for r in uniqueRs:
        if r in sampleDict[s]:
            smps = matchRDict[r]
            matchRSmps.append(smps)


            
# create dictionaries { sample : [[ read, scores, id ], [ read, scores, id ] ... ] }
matchRSmpsDict = { list(sampleDict.keys())[s] : matchRSmps[s] for s in range(len(sampleDict)) }
matchFSmpsDict = { list(sampleDict.keys())[s] : matchFSmps[s] for s in range(len(sampleDict)) }




# turn into matrix
sampleNames = list(sampleDict.keys())

matrixR = np.array([matchRSmpsDict[i] for i in sampleNames])
matrixF = np.array([matchFSmpsDict[i] for i in sampleNames])




# extract columns from matrix
def column(matrix, i):
    return [row[i] for row in matrix]





# determine what @seqs belong to what samples

seqsToSmps = []
for i in range(len(sampleNames)):
        if set(column(matrixF[i], 2)) & set(column(matrixR[i], 2)):
            seqs = list(set(column(matrixF[i], 2)) & set(column(matrixR[i], 2)))
            seqsToSmps.append(seqs)



# create dictionary { sample : [ @seq, @seq, @seq ] }
seqsToSmpsDict = { sampleNames[i] : seqsToSmps[i] for i in range(len(sampleNames)) }



# convert to matrix
seqsToSmpsMatrix = np.array([seqsToSmpsDict[i] for i in sampleNames])



# create dictionary { sample : [ [ @seq, scores, read ], [ @seq, scores, read ] ... ] }
mappedF = {}

for i in range(len(sampleNames)):
    mappedF.setdefault(sampleNames[i], [])
    
    for j in range(len(seqsToSmpsMatrix[i])):
        k = seqsToSmpsMatrix[i,j]
        l = list(R1Dict[k])
        mappedF[sampleNames[i]].append(l)


mappedR = {}

for i in range(len(sampleNames)):
    mappedR.setdefault(sampleNames[i], [])
    
    for j in range(len(seqsToSmpsMatrix[i])):
        k = seqsToSmpsMatrix[i,j]
        l = list(R2Dict[k])
        mappedR[sampleNames[i]].append(l)






# convert to matrices

matrixMappedF = np.array([mappedF[i] for i in sampleNames])
matrixMappedR = np.array([mappedR[i] for i in sampleNames])






# save :) :) :) :)

for i in range(len(sampleNames)):
    with open("{}_R1.fastq".format(sampleNames[i]), "w") as finalF:
    
        for j in range(len(matrixMappedF[i])):
            finalF.write("%s\r\n" % column(matrixMappedF[i], 2)[j])
            finalF.write("%s\r\n" % column(matrixMappedF[i], 0)[j])
            finalF.write("+\r\n")
            finalF.write("%s\r\n" % column(matrixMappedF[i], 1)[j])

        
finalF.close()


for i in range(len(sampleNames)):
    with open("{}_R2.fastq".format(sampleNames[i]), "w") as finalR:
    
        for j in range(len(matrixMappedR[i])):
            finalR.write("%s\r\n" % column(matrixMappedR[i], 2)[j])
            finalR.write("%s\r\n" % column(matrixMappedR[i], 0)[j])
            finalR.write("+\r\n")
            finalR.write("%s\r\n" % column(matrixMappedR[i], 1)[j])

        
finalR.close()






# verbose
print("\n\n\n= = = = = = = = = = = = =\n"\
      "= = = = = = = = = = = = =\n\n\n"\
      "%i unique reads sorted into %i R1 and R2 files.\n\n" %
      (len(R1Dict) + len(R2Dict), len(sampleDict)))




