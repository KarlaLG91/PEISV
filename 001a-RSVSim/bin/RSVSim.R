## DESCRIPTION:
## R script to run RSVSim algorithm in order to simulate structural variants (SVs), including Deletions, Duplications, Inversions, Insertions and Translocations.
## The script uses a reference genome in the form of a FASTA file to simulate different types of SVs.
## The script also generates a FASTA file with the simulated, rearranged genome including the SVs.
##
## USAGE:
## This R script is called by the mkfile of this module with the following command:
##	`Rscript --vanilla bin/RSVSim.R <Path to REFERENCE> <Output file> <SV_SIZE> <SV_NUMBER> <SV_TYPE>`; 
##					where <Path to REFERENCE> is the path to any file in data/, 
##					<Output file> is any line printed by the `/bin/create-targets` script in this module,
##					<SV_SIZE> is the variable $SV_SIZE found in the `config.mk` file in this module,
##					<SV_NUMBER> is the variable $SV_NUMBER found in the `config.mk` file in this module,
##					and <SV_TYPE> is the variable $SV_TYPE found in the `config.mk` file in this module. 
## AUTHOR:
##      Karla Lozano (klg1219sh@gmail.com), for Winter Genomics (http://www.wintergenomics.com/) - 2018


# Reading arguments from shell
#
args = commandArgs(trailingOnly = TRUE)

#args[1]= path to genome
#args[2]= output directory
#args[3]= size of SVs
#args[4]= number of SV event (can be used for any type of event)
#args[5]= type of SV to generate; currently, the script uses conditionals to check what type of SV it will generate

# Loading the package RSVSim
#
library(RSVSim)

# Simulating SV
#
## Setting the variable chr_vector
chr_vector <- c("chr21" , "chr22")

# for deletions:
if ( args[5] == "DEL" ) {
	simulateSV(output= args[2], genome= args[1], 
		chr=c(chr_vector),
		dels= as.numeric(args[4]), 
		size= as.numeric(args[3]), 
		repeatBias=FALSE, 
	## by commenting this argument, it should be set to default
	#	bpSeqize=150, 
		random=TRUE, 
		seed=666, 
		verbose=TRUE)
}

# For insertions
if ( args[5] == "INS" ) {
        simulateSV(output= args[2], genome= args[1],
                chr=c(chr_vector),
                ins= as.numeric(args[4]), ## <- THIS LINE changes depending on the type of SV requested
                size= as.numeric(args[3]),
		percCopiedIns=1,
                repeatBias=FALSE,
        #       bpSeqize=150,
                random=TRUE,
                seed=666,
                verbose=TRUE)
}

# For inversions
if ( args[5] == "INV" ) {
        simulateSV(output= args[2], genome= args[1],
                chr=c(chr_vector),
                invs= as.numeric(args[4]), ## <- THIS LINE changes depending on the type of SV requested
                size= as.numeric(args[3]),
                repeatBias=FALSE,
        #       bpSeqize=150,
                random=TRUE,
                seed=666,
                verbose=TRUE)
}

# For duplications
if ( args[5] == "DUP" ) {
        simulateSV(output= args[2], genome= args[1],
                chr=c(chr_vector),
                dups= as.numeric(args[4]), ## <- THIS LINE changes depending on the type of SV requested
                size= as.numeric(args[3]),
                maxDups=5,
                repeatBias=FALSE,
        #       bpSeqize=150,
                random=TRUE,
                seed=666,
                verbose=TRUE)
}

# For translocations
if ( args[5] == "TRA" ) {
        simulateSV(output= args[2], genome= args[1],
                chr=c(chr_vector),
                trans= as.numeric(args[4]), ## <- THIS LINE changes depending on the type of SV requested
                size= as.numeric(args[3]),
                percBalancedTrans=1,
                repeatBias=FALSE,
        #       bpSeqize=150,
                random=TRUE,
                seed=666,
                verbose=TRUE)
}
