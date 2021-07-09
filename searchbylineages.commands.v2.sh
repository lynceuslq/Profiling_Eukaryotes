#!bin/bash

TAXNAMES="/hwfssz5/ST_INFECTION/GlobalDatabase/user/liqian6/taxdump/taxanames.txt"
TAXREPORT="/hwfssz5/ST_INFECTION/GlobalDatabase/user/liqian6/taxdump/tax_report.txt"

helpFunction()
{
   echo ""
   echo "Usage: $0 -t taxon -s KS_file -l level -i Inpath -o Outpath"
   echo -e "\t-t which taxon to retrive"
   echo -e "\t-s which kraken style result to look up"
   echo -e "\t-l which taxonomic level to present, please select from S, G, F, O, C, P, K"
   echo -e "\t-i which directory the kraken style centrifuge result is located"
   echo -e "\t-o which directory to write the results"
   exit 1 # Exit script after printing help
}

while getopts "t:s:l:i:o:" opt
do
   case "$opt" in
      t ) taxon="$OPTARG" ;;
      s ) sample="$OPTARG" ;;
      l ) level="$OPTARG" ;;
      i ) Inpath="$OPTARG" ;;
      o ) Outpath="$OPTARG" ;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

#read -p "which taxon to look up: " taxon
#read -p "which sample to look up: " sample
#read -p "which taxonomic level to present: " level
if [ -z "$taxon" ] || [ -z "$sample" ] || [ -z "$level" ] || [ -z "$Inpath" ] || [ -z "$Outpath" ]
then
   echo "Some or all of the parameters are empty";
   helpFunction
else
   echo -e "start to sort species from $taxon in file $sample, results presented at the level of $level\t$(date)"
   taxid=$(cat $TAXNAMES | awk -v m="${taxon}" '{FS="\t"; if($2 == m) {print}}' | cut -f1)

   grep -w "${taxid// /}" $TAXREPORT | cut -d "|" -f4 | sed "s/\t//" | tr " " "\n" | sort | uniq | tail -n +2 | while read tax; do awk -v t="$tax" '$5 == t' $Inpath/${sample// /} ; done |  awk -v p="$level" '$4 == p'  > $Outpath/tmpfile
   Sum=$(cut -f1 $Outpath/tmpfile | paste -sd+ - | bc)
   cat $Outpath/tmpfile | sed 's/^ *//g' | cut -f1,2,3,4,5,6,7 > $Outpath/c1 
   cat $Outpath/tmpfile | sed 's/^ *//g' | cut -f8 | sed 's/^ *//g' > $Outpath/c2 
   cat $Outpath/tmpfile | awk -v s="$Sum" '{print $1 / s;}' > $Outpath/c3
   paste  $Outpath/c1  $Outpath/c2 $Outpath/c3 | sort -n -r -k1,1 >  $Outpath/${sample// /}.sortby${taxon// /}_${level// /}

   rm $Outpath/c1  $Outpath/c2 $Outpath/c3

   echo -e "sorting species from $taxon in file $sample completed, results stored in $Outpath\t$(date)"

fi
