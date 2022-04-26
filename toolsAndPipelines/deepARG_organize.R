
###############################################
### organizing results from deepARG online tool
### Lou LaMartina, April 22, 2020
###############################################


# the online deepARG tool (https://bench.cs.vt.edu/deeparg_analyze/)
# yields 3 files per sample:
#   - ARG subtypes (eg. tetG) counts & relative to 16S
#   - ARG types (eg. tetracycline) counts & relative to 16S
#   - full files (subtypes and types)

# here, load each into R and get into usable data frames


# set working directory and paths
setwd("~/Desktop/Lab/Projects/Metagenomics/DeepARG")
path <- "./Online tool"


# find deepARG files
full_files <- sort(list.files(path, pattern = "\\.full-table.txt", full.names = TRUE))
subtype_files <- sort(list.files(path, pattern = ".subtype.txt", full.names = TRUE))
type_files <- sort(list.files(path, pattern = "\\.type.txt", full.names = TRUE))


# upload files into lists
full_files.ls <- list()
for(file in full_files){
  full_files.ls[[file]] <- read.table(file, header = TRUE)
  full_files.ls[[file]]$Sample_name <- sapply(strsplit(basename(file), "\\."), '[', 1)
}

subtype_files.ls <- list()
for(file in subtype_files){
  subtype_files.ls[[file]] <- read.table(file)
  colnames(subtype_files.ls[[file]]) <- c("ARG_group", "Count", "Normalized_16S")
  subtype_files.ls[[file]]$Sample_name <- sapply(strsplit(basename(file), "\\."), '[', 1)
}

type_files.ls <- list()
for(file in type_files){
  type_files.ls[[file]] <- read.table(file)
  colnames(type_files.ls[[file]]) <- c("ARG_group", "Count", "Normalized_16S")
  type_files.ls[[file]]$Sample_name <- sapply(strsplit(basename(file), "\\."), '[', 1)
}


# combine them into data frames
full_files.df <- do.call(rbind, full_files.ls)
rownames(full_files.df) <- 1:nrow(full_files.df)

subtype_files.df <- do.call(rbind, subtype_files.ls)
rownames(subtype_files.df) <- 1:nrow(subtype_files.df)

type_files.df <- do.call(rbind, type_files.ls)
rownames(type_files.df) <- 1:nrow(type_files.df)

