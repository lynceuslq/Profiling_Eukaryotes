#!bin/bash

Inpath="/hwfssz5/ST_INFECTION/GlobalDatabase/user/liqian6/taxdump"
Outpath="/hwfssz5/ST_INFECTION/GlobalDatabase/user/liqian6/taxdump/sortbylineage_results"

read -p "which taxon to look up: " taxon
read -p "which sample to look up: " sample
read -p "which taxonomic level to present: " level
echo -e "start to sort species from $taxon in sample $sample\t$(date)"
taxid=$(cat $Inpath/taxanames.txt | awk -v m="${taxon}" '{FS="\t"; if($2 == m) {print}}' | cut -f1)

grep -w "${taxid// /}" $Inpath/tax_report.txt | cut -d "|" -f4 | sed "s/\t//" | tr " " "\n" | sort | uniq | tail -n +2 | while read tax; do awk -v t="$tax" '$5 == t' $Inpath/results/${sample// /}.centrifuge.KSout ; done |  awk -v p="$level" '$4 == p'  > $Outpath/tmpfile

cat $Outpath/tmpfile | sed 's/^ *//g' | cut -f1,2,3,4,5,6,7 > $Outpath/c1 
cat $Outpath/tmpfile | sed 's/^ *//g' | cut -f8 | sed 's/^ *//g' > $Outpath/c2 

paste  $Outpath/c1  $Outpath/c2 | sort -n -r -k1,1 >  $Outpath/${sample// /}.centrifuge.sortby${taxon// /}

rm $Outpath/c1  $Outpath/c2

echo -e "sorting species from $taxon in sample $sample completed\t$(date)"
