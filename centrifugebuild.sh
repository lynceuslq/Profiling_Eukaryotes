#!/bin/bash
export PATH="/hwfssz5/ST_INFECTION/GlobalDatabase/user/fengqikai/software/.conda/envs/Trinity-2.11.0/bin/:$PATH"
export PATH="/hwfssz5/ST_INFECTION/GlobalDatabase/user/liqian6/tools/centrifuge-1.0.3-beta:$PATH"

echo -e "job starting at: $(date)"

centrifuge-build -p 16 --conversion-table /hwfssz5/ST_INFECTION/GlobalDatabase/user/liqian6/taxdump/cox1_v4.conv  --taxonomy-tree /hwfssz5/ST_INFECTION/GlobalDatabase/user/liqian6/taxdump/nodes.dmp --name-table /hwfssz5/ST_INFECTION/GlobalDatabase/user/liqian6/taxdump/names.dmp /hwfssz5/ST_INFECTION/GlobalDatabase/user/liqian6/taxdump/input-sequences.fna  cox1_index

echo -e "job completed at $(date)"
