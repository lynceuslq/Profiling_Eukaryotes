#!/bin/bash


Inpath="/hwfssz5/ST_INFECTION/GlobalDatabase/user/liqian6/taxdump"
Outpath="/hwfssz5/ST_INFECTION/GlobalDatabase/user/liqian6/taxdump"

echo -e "job starting at $(date)"

cat $Inpath/taxaforcox1.txt | while read taxid; do  awk -v d="$taxid" '$1 == d' $Inpath/names.dmp | grep "scientific name" >> $Outpath/cox1taxanames.dmp; done

echo -e "job completed at $(date)"
