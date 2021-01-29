#######################
### Quality control ###
#######################

# give filtered files new names and paths
filtered_Fs <- file.path(filtered_pathF, paste0(Sample_names, "_F_filt.fastq"))
filtered_Rs <- file.path(filtered_pathR, paste0(Sample_names, "_R_filt.fastq"))


# # # # # # # # # # # # # # # # # # # # # # # # # #
### FOR LARGE DATASETS (>100 files)

# what is the maximum number of files you want to 
# filterAndTrim at the same time?
# for example, if you have 110 files, 
# and you want to process only 20 at a time,
# we will process five sets of 20 and
# one set of 10.
# put your answer here:

maxN = 20

# then run the code below.
# # # # # # # # # # # # # # # # # # # # # # # # # # 


# define variables
intN = length(fastqFs) %/% maxN
remN = length(fastqFs) %% maxN



##############
### unfiltered

# create sets of files
fastqFsets.ls <- list()

for(i in c(seq(length(fastqFs) %/% maxN), intN + 1)) {  
  fastqFsets.ls[[i]] <- fastqFs[(maxN * (i - 1) + 1) : (i * maxN)]  
  fastqFsets.ls[[intN + 1]] <- fastqFs[(maxN * intN + 1) : length(fastqFs)]
}


# do same for Rs by changing file names
fastqRsets.ls <- list()

for(f in 1:length(fastqFsets.ls)){  
  fastqRsets.ls[[f]] <- sub("fastqF", "fastqR", sub("_R1", "_R2", fastqFsets.ls[[f]]))
}



############
### filtered

# create sets of files
filtFsets.ls <- list()

for(i in c(seq(length(filtered_Fs) %/% maxN), intN + 1)) {  
  filtFsets.ls[[i]] <- filtered_Fs[(maxN * (i - 1) + 1) : (i * maxN)]  
  filtFsets.ls[[intN + 1]] <- filtered_Fs[(maxN * intN + 1) : length(filtered_Fs)]
}


# do same for Rs by changing file names
filtRsets.ls <- list()

for(f in 1:length(filtFsets.ls)){
  filtRsets.ls[[f]] <- sub("fastqF", "fastqR", sub("F_filt", "R_filt", filtFsets.ls[[f]]))

}



###################
### filter and trim

filtered_out.ls <- list()

for(j in 1:length(fastqFsets.ls)) {
  cat("\n", format(Sys.time(), "%H:%M %p"), " - Filtering set ", j, " . . . \n")
  filtered_out.ls[[j]] <- filterAndTrim(fastqFsets.ls[[j]], filtFsets.ls[[j]],
                                        fastqRsets.ls[[j]], filtRsets.ls[[j]],
                                        maxEE = 2, maxN = 0, truncQ = 10,
                                        rm.phix = TRUE, compress = TRUE, 
                                        verbose = TRUE, multithread = TRUE)
}


# inspect how many reads were filtered out of each sample
filtered_out <- do.call(rbind, filtered_out.ls)
(1 - (filtered_out[,2] / filtered_out[,1])) * 100
mean((1 - (filtered_out[,2] / filtered_out[,1])) * 100)
# [1] 23.16235 % removed


# plot quality profiles of filtered reads
filt_qualityF <- plotQualityProfile(filtered_Fs[1:4]); filt_qualityF
filt_qualityR <- plotQualityProfile(filtered_Rs[1:4]); filt_qualityF


# save quality profiles
ggsave("./Plots/filt_qualityF.pdf", plot = filt_qualityF, device = "pdf", width = 12, height = 8, units = "in")
ggsave("./Plots/filt_qualityR.pdf", plot = filt_qualityR, device = "pdf", width = 12, height = 8, units = "in")


# set sample names to the ID only
names(filtered_Fs) <- Sample_names
names(filtered_Rs) <- Sample_names
