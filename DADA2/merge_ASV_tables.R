###########################################
### combine & analyze microbial communities
### from different datasets
### Lou LaMartina, started Jan 29 2021
###########################################


# # # # # # # # # # # # # # # # # # # # # # # # # # #
# i have several CSV files, each with sample names
# as rows and ASVs (FASTA sequences) as columns.

# i want to:
#   1. load all CSVs simultaneously
#   2. store them in a list
#   3. merge them by their FASTAs
#   4. give each sample a source dataset name

# so in the end, i will have one large matrix with
# ALL sample names as rows, and all UNIQUE ASVs
# as columns.
# # # # # # # # # # # # # # # # # # # # # # # # # # #



########################
### load & prep data ###
########################

# read in files
relabun_files.ls <- lapply(list.files(), function(i) read.csv(i))


# name each dataset
names(relabun_files.ls) <- sapply(strsplit(basename(list.files()), "_"), '[', 1)


# make FASTAs their own column:
# make sample names row names, 
# remove sample name column, 
# transpose -> FASTAs as rows, 
# make new row names (FASTAs) their own column
for(i in 1:length(relabun_files.ls)){
  rownames(relabun_files.ls[[i]]) <- relabun_files.ls[[i]]$Sample_name
  relabun_files.ls[[i]] <- relabun_files.ls[[i]][-1]
  relabun_files.ls[[i]] <- data.frame(t(relabun_files.ls[[i]]))
  relabun_files.ls[[i]] <- data.frame(FASTA = rownames(relabun_files.ls[[i]]), relabun_files.ls[[i]])
}




##################
### merge data ###
##################

# merge all datasets by their FASTAs
merged_files.ls <- list()

for (i in 1:length(relabun_files.ls)) {
  if (i == 1) {
    merged_files.ls[[i]] <- merge(relabun_files.ls[[i]], 
                                  relabun_files.ls[[i + 1]], by = "FASTA", all = TRUE)
  } else if (i > 1 & i < length(relabun_files.ls)) {
    merged_files.ls[[i]] <- merge(merged_files.ls[[i - 1]], 
                                  relabun_files.ls[[i + 1]], by = "FASTA", all = TRUE)
  }
}


# extract the last one - merge() makes you do it one by one
merged_data <- data.frame(merged_files.ls[[length(relabun_files.ls) - 1]])
merged_data[is.na(merged_data)] <- 0




############################
### add dataset variable ###
############################

# transpose -> samples as rows
rownames(merged_data) <- merged_data$FASTA
merged_data <- t(merged_data[-1])


# add sample name variable
merged_data <- data.frame(Sample_name = rownames(merged_data), merged_data)


# extract sample names & store in new list
names.ls <- list()

for(i in 1:length(relabun_files.ls)) {
  names.ls[[i]] <- names(relabun_files.ls[[i]][-1])
}


# add dataset name (line 33)
names(names.ls) <- names(relabun_files.ls)


# turn into data frame
names <- data.frame(Sample_name = unlist(names.ls))
names$Source <- gsub("[[:digit:]]+", "", rownames(names))


# add the data set name to final data by merging
merged_data <- merge(names, merged_data, by = "Sample_name")

# :)



# # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # 

### test merging

# same # of samples?
ncol(relabun_files.ls[[1]]) +
  ncol(relabun_files.ls[[2]]) - 1 == ncol(merged_files.ls[[1]])
# [1] TRUE


# same # of ASVs?
length(unique(c(as.character(relabun_files.ls[[1]]$FASTA),
                as.character(relabun_files.ls[[2]]$FASTA)))) == 
  nrow(merged_files.ls[[1]])
# [1] TRUE


# does merging work?
identical(merged_files.ls[[1]],
          merge(relabun_files.ls[[1]], relabun_files.ls[[2]], by = "FASTA", all = TRUE))
# [1] TRUE


# visualize
gplots::venn(list(file1 = relabun_files.ls[[1]]$FASTA, file2 = relabun_files.ls[[2]]$FASTA))


