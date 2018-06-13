# mk-001a-RSVSim - Pipeline for the simulation of structural variations in any genome.

### Abbreviations

-**SVs**: Structural variations.

## About mk-001a-RSVSim

**Objective:**

This module simulates SVs of different sizes in any genome in a FASTA file format using the RSVSim algorithm.

## Module description

In the process of choosing the most suitable detecting SV tool, assessing the performance of the available algorithms with a set of simulated SVs is vital. Generating a set of known SVs allows the evaluation of the sensibility and precision of SV callers.

RSVSim is capable of simulating _five types_ of SVs: **_deletions_**, **_insertions_**, **_inversions_**, **_tandem duplications_** and **_translocations_**.

In the case of _deletions_, a sequence is removed from the genome and ends are joined together. For _insertions_, a segment is removed or duplicated from one location and is inserted into the same or other chromosome. An _inversion_ involves a cut of a segment and the insertion of the reverse compliment at the same position without loss of sequence. In regards to _tandem duplications_, a sequence is repeated consecutively multiple times. And, for _translocations_  segments from the genome are taken and inserted o the same chromosomes (intra-chromosomal translocation) or different chromosomes (inter-chromosomal translocation). Translocations can be balanced (no gain/loss of genome segments) or unbalanced (gain/loss of genome segments). 

For all cases, except transocations, the size of te SV can be specified. The SVs are placed in a non-overlapping manner and unnannotated regions or assembly gaps are excluded from the simulation. [[1]](https://academic.oup.com/bioinformatics/article/29/13/1679/185706)

In this module RSVSim uses a reference genome in FASTA file format [[2]](https://blast.ncbi.nlm.nih.gov/Blast.cgi?CMD=Web&PAGE_TYPE=BlastDocs&DOC_TYPE=BlastHelp) as input to modify the sequences and generate de requested simulations. The ooutput is a FASTA file fwith the rearranged genome and CSV files with the list of simulated SVs, including location, size and breakpoint sequence.

````
IMPORTANT NOTE:

Although, RSVSim can simulate deletions , inversions, tandem duplications, insertions and translocations. Only the first three were tested succesfully. 
The methodology followed by the algorithm to generate insertions and translocations complictes the comparison of the results between detected SVs and simulated SVs.
Insertions involve a simultaneous deletion and insertion, or a duplication and a non-consecutive insertion. 
In case of translocations, the SV is simulated at the start or end of the chromosome, therefore complicating the detection by the SV callers. 

````
RSVSim installation instructions can be found at: [https://bioconductor.org/packages/release/bioc/html/RSVSim.html](https://bioconductor.org/packages/release/bioc/html/RSVSim.html) 
RSVSim publication can be found at: [https://academic.oup.com/bioinformatics/article/29/13/1679/185706](https://academic.oup.com/bioinformatics/article/29/13/1679/185706) 

## Pipeline configuration

### Data formats:

**Input**

 - Genome in FASTA file format

**Output**

 - FASTA file of the rearranged genome with the simulated SVs.
 - Files in CSV format including the list of simulated SVs, with the respective locations, sizes and breakpoint sequences.

### Software dependencies:

* [mk](https://9fans.github.io/plan9port/man/man1/mk.html "A successor for make.")

* [RSVSim](https://bioconductor.org/packages/release/bioc/html/RSVSim.html)  version 1.20.0 (R package)

### Configuration file

This pipeline includes a config.mk files (located at mk-001a-RSVSim/config.mk), where you can adjust several parameters:

````

# Define the size of SV to simulate
SV_size= Must be a numerical number specifying the size of the simulated SV.

# Define the number of SV to simulate
SV_number= Must be a numerical number specifying the number of SVs to be simulated.

# Define the type of SV to simulate. (accepted types are DEL, INS, INV, DUP, TRA, ALL)
## Comment or uncomment lines to change the type of event being generated
SV_TYPE="DEL"
#SV_TYPE="INS"
#SV_TYPE="INV"
#SV_TYPE="DUP"
#SV_TYPE="TRA"
#SV_TYPE="ALL"

````

### Module parameters

Used by RSVSim: used by bin/RSVSim.R

````

args = commandArgs(trailingOnly = TRUE)	-> Reading arguments from shell

library(RSVSim)	-> Loading the package RSVSim

# Simulating SV

chr_vector <- c("chr21" , "chr22")		-> Setting the regions to simulate SVs

# for deletions:
if ( args[5] == "DEL" ) {		-> In case of simulating deletions.
	simulateSV(output= args[2], 	-> Defining output file
		genome= args[1], 			-> Specifying reference genome
		chr=c(chr_vector),			-> Setting specified regions
		dels= as.numeric(args[4]), 	-> Defining number of deletions to simulate (Line changes depending on the type of SV requested)
		size= as.numeric(args[3]), 	-> Specifying size of deletions
		repeatBias=FALSE, 		-> If TRUE, the breakpoint positioning is biased towards repeat regions instead of a uniform distribution.
		random=TRUE, 			-> If TRUE, the SVs will be placed randomly within the genome or the given regions; otherwise, the given regions will be used as SV coordinates
		seed=666, 				-> Fixed seed for generation of random SV positions
		verbose=TRUE) 			-> If TRUE, some messages about the progress of the simulation will be printed into the R console
}

# For insertions
if ( args[5] == "INS" ) {				-> In case of simulating insertions
        simulateSV(output= args[2], 	-> Defining output file
        	genome= args[1],			-> Specifying reference genome
                chr=c(chr_vector),			-> Setting specified regions
                ins= as.numeric(args[4]), 	-> Defining number of insertions to simulate (Line changes depending on the type of SV requested)
                size= as.numeric(args[3]),	-> Specifying size of insertions
		percCopiedIns=1,			->Percentage of copy-and-paste-like insertions (default: 0, i.e. no inserted sequences are duplicated)
                repeatBias=FALSE,			-> If TRUE, the breakpoint positioning is biased towards repeat regions instead of a uniform distribution.
                random=TRUE,			-> If TRUE, the SVs will be placed randomly within the genome or the given regions; otherwise, the given regions will be used as SV coordinates
                seed=666,				-> Fixed seed for generation of random SV positions
                verbose=TRUE)			-> If TRUE, some messages about the progress of the simulation will be printed into the R console
}

# For inversions
if ( args[5] == "INV" ) {				-> In case of simulating inversions
        simulateSV(output= args[2], 	-> Defining output file
        	genome= args[1],			-> Specifying reference genome
                chr=c(chr_vector),			-> Setting specified regions
                invs= as.numeric(args[4]), 	-> Defining number of insertions to simulate (Line changes depending on the type of SV requested)
                size= as.numeric(args[3]),	-> Specifying size of inversions
                repeatBias=FALSE,			-> If TRUE, the breakpoint positioning is biased towards repeat regions instead of a uniform distribution.
                random=TRUE,			-> If TRUE, the SVs will be placed randomly within the genome or the given regions; otherwise, the given regions will be used as SV coordinates
                seed=666,				-> Fixed seed for generation of random SV positions
                verbose=TRUE)			-> If TRUE, some messages about the progress of the simulation will be printed into the R console
}

# For duplications
if ( args[5] == "DUP" ) {			-> In case of simulating duplications
        simulateSV(output= args[2], 	-> Defining output file
        	genome= args[1],			-> Specifying reference genome
                chr=c(chr_vector),			-> Setting specified regions
                dups= as.numeric(args[4]), 	-> Defining number of insertions to simulate (Line changes depending on the type of SV requested)
                size= as.numeric(args[3]),	-> Specifying size of duplications
                maxDups=5,				-> Maximum number of repeats for tandem duplications
                repeatBias=FALSE,			-> If TRUE, the breakpoint positioning is biased towards repeat regions instead of a uniform distribution.
                random=TRUE,			-> If TRUE, the SVs will be placed randomly within the genome or the given regions; otherwise, the given regions will be used as SV coordinates
                seed=666,				-> Fixed seed for generation of random SV positions
                verbose=TRUE)			-> If TRUE, some messages about the progress of the simulation will be printed into the R console
}

# For translocations
if ( args[5] == "TRA" ) {				-> In case of simulating translocations
        simulateSV(output= args[2], 	-> Defining output file
        	genome= args[1],			-> Specifying reference genome
                chr=c(chr_vector),			-> Setting specified regions
                trans= as.numeric(args[4]), 	-> Defining number of insertions to simulate (Line changes depending on the type of SV requested)
                size= as.numeric(args[3]),	-> Specifying size of translocations
                percBalancedTrans=1,		-> Percentage of balanced translocations (default: 1, i.e. all translocations are balanced)
                repeatBias=FALSE,			-> If TRUE, the breakpoint positioning is biased towards repeat regions instead of a uniform distribution.
                random=TRUE,			-> If TRUE, the SVs will be placed randomly within the genome or the given regions; otherwise, the given regions will be used as SV coordinates
                seed=666,				-> Fixed seed for generation of random SV positions
                verbose=TRUE)			-> If TRUE, some messages about the progress of the simulation will be printed into the R console
}


# For events of each type (Deletions, Duplications, Inversions)

if ( args[5] == "ALL" ) {				-> In case of simulating deletions, duplications and inversions simultaneously.
        simulateSV(output= args[2], 	-> Defining output file
        	genome= args[1],			-> Specifying reference genome
                chr=c(chr_vector),			-> Setting specified regions
                dels= as.numeric(args[4]),	-> Defining number of deletions to simulate
		dups= as.numeric(args[4]),	-> Defining number of duplications to simulate
		invs= as.numeric(args[4]),	-> Defining number of inversions to simulate
                size= as.numeric(args[3]),	-> Specifying size of duplications
                maxDups=5,				-> Maximum number of repeats for tandem duplications
                repeatBias=FALSE,			-> If TRUE, the breakpoint positioning is biased towards repeat regions instead of a uniform distribution.
                random=TRUE,			-> If TRUE, the SVs will be placed randomly within the genome or the given regions; otherwise, the given regions will be used as SV coordinates
                seed=666,				-> Fixed seed for generation of random SV positions
                verbose=TRUE)			-> If TRUE, some messages about the progress of the simulation will be printed into the R console
}


````


## mk-001a-RSVSim directory structure


````
mk-001a-RSVSim 		##Module main directory.
├── bin				##Executables directory.
│   ├── RSVSim.R		##Script to run RSVSim.
│   └── create-targets	##Script to print every file required by this module.
├── config.mk			##Configuration file for this module.
├── data -> **MISSING**	##Symbolic link to data for processing
├── mkfile			##File in mk format, specifying the rules for building every result requested by bin/create_targets.
├── README.md		##This document. General workflow description.
└── results			##Storage directory for files built by mkfile. If it does not exist, it is automatically generated by mkfile.

````


## References.

\[1\] [RSVSim algorithm](https://academic.oup.com/bioinformatics/article/29/13/1679/185706) 
\[2\] [FASTA format](https://blast.ncbi.nlm.nih.gov/Blast.cgi?CMD=Web&PAGE_TYPE=BlastDocs&DOC_TYPE=BlastHelp) 
\[3\] [RSVSim manual](https://bioconductor.org/packages/release/bioc/manuals/RSVSim/man/RSVSim.pdf) 

### Author Info.
Developed by Karla Lozano (klg1219sh@gmail.com) for [Winter Genomics](http://www.wintergenomics.com/) 2018.