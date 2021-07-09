#!/bin/bash

export PATH="/hwfssz5/ST_INFECTION/GlobalDatabase/user/liqian6/tools/centrifuge-1.0.3-beta:$PATH"
Index="/hwfssz5/ST_INFECTION/GlobalDatabase/user/liqian6/tools/centrifuge-1.0.3-beta/example/reference/test"
Inputfa="/hwfssz5/ST_INFECTION/GlobalDatabase/user/liqian6/tools/centrifuge-1.0.3-beta/example/reads/input.fa"
Outputfile="/hwfssz5/ST_INFECTION/GlobalDatabase/user/liqian6/tools/centrifuge-1.0.3-beta/example/testcentrifuge.out"
Report="/hwfssz5/ST_INFECTION/GlobalDatabase/user/liqian6/tools/centrifuge-1.0.3-beta/example/testcentrifuge.report"
echo -e "starting at $(date)"

centrifuge -f -x $Index $Inputfa -S $Outputfile --report-file $Report -p 16 

echo -e "ending at $(date)"

echo -e "job completed"
date
