# Reading arguments from shell
#
args = commandArgs(trailingOnly = TRUE)

#args[1]= path to genome
#args[2]= output directory
#args[3]= size of SVs
#args[4]= number of SV event (can be used for any type of event)

# Loading the package RSVSim
#
library(RSVSim)

# Simulating SV
#
## Setting the variable chr_vector
chr_vector <- c("chr21" , "chr22")

# For events of each type (Deletions, Duplications, Inversions).
simulateSV(output= args[2], genome= args[1], chr=c(chr_vector),
                   dels= as.numeric(args[4]),
		   dups= as.numeric(args[4]),
		   invs= as.numeric(args[4]),
                   size= as.numeric(args[3]),
                   maxDups=5,
		   repeatBias=FALSE,
                   random=TRUE,
                   seed=666,
                   verbose=TRUE)

