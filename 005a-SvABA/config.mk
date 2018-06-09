## Here we declare the variables that are going to be used by mkfile.

#Define the BWA-MEM index reference genome.
REFERENCE="/media/genomics/disco1/klozano_bkp/PEISV/000-prepare_test_data/001a-BWA_index_genome/results/hg19.minimized.fa"

# Number of threds
NT=2

## Minimum number of somatic reads required to attempt mate-region lookup
##  Set to 6 which means that 6 or more mate reads must be clustered to 
##   trigger a mate lookup. This also reduces spurious lookups as above, and is more 
##   appropriate the expected ALT counts found in a germline sample 
##   (as opposed to impure, subclonal events in cancer that may have few discordant reads).
MR=6
