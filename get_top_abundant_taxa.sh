#!/bin/bash

#################################################please define the arguements below######################################################
Input="/PATH/TO/INPUT"
Output="/PATH/TO/OUTPUT"
sample=""#give a sample name


#################################################you do not need to change anything here#################################################
echo -e "start to generate summaries on sample $sample"
awk '$4 == "D"'  ${Input// /}/${sample// /}.centrifuge.KSout | sort -n -r -k1,1 | head -1 > $Output/tmpfile
awk '$4 == "K"'  ${Input// /}/${sample// /}.centrifuge.KSout | sort -n -r -k1,1 | head -1 >> $Output/tmpfile
awk '$4 == "P"' ${Input// /}/${sample// /}.centrifuge.KSout | sort -n -r -k1,1 | head -1 >> $Output/tmpfile
awk '$4 == "C"' ${Input// /}/${sample// /}.centrifuge.KSout | sort -n -r -k1,1 | head -1 >> $Output/tmpfile
awk '$4 == "O"' ${Input// /}/${sample// /}.centrifuge.KSout | sort -n -r -k1,1 | head -1 >> $Output/tmpfile
awk '$4 == "F"' ${Input// /}/${sample// /}.centrifuge.KSout | sort -n -r -k1,1 | head -1 >> $Output/tmpfile
awk '$4 == "G"' ${Input// /}/${sample// /}.centrifuge.KSout | sort -n -r -k1,1 | head -1 >> $Output/tmpfile
awk '$4 == "S"' ${Input// /}/${sample// /}.centrifuge.KSout | sort -n -r -k1,1 | head -1 >> $Output/tmpfile

cat $Output/tmpfile  | cut -f1,2,3,4,5,6,7 > $Output/c1
cat $Output/tmpfile  | cut -f8 | sed 's/^ *//g' > $Output/c2

paste $Output/c1 $Output/c2 > $Output/${sample// /}.centrifuge.toptaxa

rm $Output/c1 $Output/c2 $Output/tmpfile

echo -e "analysis on $sample completed at $(date)"
