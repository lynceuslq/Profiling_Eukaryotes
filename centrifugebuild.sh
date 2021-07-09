#!/bin/bash

###################################################please define the arguements below###########################################################
export PATH="/PATH/TO/PYTHON/:$PATH"
export PATH="/PATH/TO/centrifuge-1.0.3-beta:$PATH"
OUTDIR="/PATH/TO/INDEX"
INDEX=""#give you index a name
TAXDUMP="/PATH/TO/taxdump"#can be decompressed from taxdump.tar.gz, a taxonomy file from NCBI
FASTA=""#a fasta file of CDS with GI accessions
CONVERSION=""#a table of CDS GI accession and its taxid

##################################################you do not need to change anything below#######################################################
echo -e "start to build index at: $(date)"

centrifuge-build -p 16 --conversion-table  $CONVERSION --taxonomy-tree $TAXDUMP/nodes.dmp --name-table $TAXDUMP/names.dmp $FASTA $CONVERSION

echo -e "job completed at $(date), index stored as $OUTDIR/$INDEX"
