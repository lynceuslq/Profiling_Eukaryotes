#!/bin/bash
export PATH="/hwfssz5/ST_INFECTION/GlobalDatabase/user/liqian6/tools/metagen-master:$PATH"
export PATH="/hwfssz5/ST_INFECTION/GlobalDatabase/user/liqian6/tools/centrifuge-1.0.3-beta:$PATH"
Index="/hwfssz5/ST_INFECTION/GlobalDatabase/user/liqian6/taxdump/cox1_index"
Inputfqpath="/hwfssz5/ST_INFECTION/GlobalDatabase/user/liqian6/taxdump/testfq"
Outputfiledir="/hwfssz5/ST_INFECTION/GlobalDatabase/user/liqian6/taxdump/results"
Sample="R2011005908_0_20201222"

echo -e "starting at $(date)"
echo -e "working on sample $Sample"

centrifuge -q -x $Index -1 $Inputfqpath/${Sample// /}_1_rmRNA.fq.gz -2 $Inputfqpath/${Sample// /}_2_rmRNA.fq.gz  -S $Outputfiledir/${Sample// /}.centrifuge.out --report-file $Outputfiledir/${Sample// /}.centrifuge.report  -p 32

centrifuge-kreport -x $Index  $Outputfiledir/${Sample// /}.centrifuge.out  > $Outputfiledir/${Sample// /}.centrifuge.KSout

cat $Outputfiledir/${Sample// /}.centrifuge.report  | tr "\t" "+" | sort -t+  -n -r -k7,7 -k6,6 -k5,5 | tr "+" "\t"  >  $Outputfiledir/${Sample// /}.centrifuge.report.sorted


echo -e "ending at $(date)"

echo -e "job completed"
date
