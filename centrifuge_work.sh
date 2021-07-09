#!/bin/bash
export PATH="/PATH/TO/metagen-master:$PATH" #you can clone the repo from https://github.com/jsh58/metagen.git
export PATH="/PATH/TO/centrifuge-1.0.3-beta:$PATH" #you can get a Linux version here ftp://ftp.ccb.jhu.edu/pub/infphilo/centrifuge/downloads/centrifuge-1.0.3-beta-Linux_x86_64.zip
Index="/PATH/to/cox1_index" #you can get a presetted index here 
Inputfqpath="/PATH/TO/FQ_FILES"
Outputfiledir="/PATH/TO/OUTPUT/DIRECTORY"
Sample="a_string" #lets give output a name

echo -e "starting at $(date)"
echo -e "working on sample $Sample"

centrifuge -q -x $Index -1 $Inputfqpath/${Sample// /}_1_rmRNA.fq.gz -2 $Inputfqpath/${Sample// /}_2_rmRNA.fq.gz  -S $Outputfiledir/${Sample// /}.centrifuge.out --report-file $Outputfiledir/${Sample// /}.centrifuge.report  -p 32

centrifuge-kreport -x $Index  $Outputfiledir/${Sample// /}.centrifuge.out  > $Outputfiledir/${Sample// /}.centrifuge.KSout

cat $Outputfiledir/${Sample// /}.centrifuge.report  | tr "\t" "+" | sort -t+  -n -r -k7,7 -k6,6 -k5,5 | tr "+" "\t"  >  $Outputfiledir/${Sample// /}.centrifuge.report.sorted


echo -e "ending at $(date)"

echo -e "job completed"
date
