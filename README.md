# Profiling_Eukaryotes
To identify potential eukaryotic components and their compositions in a meta-genome with Centrifuge, as an indication for biological composition in different environments or  evidence of host-parasite interaction


1. Propfile eukaryotic compositions with preformatted index 

why to use preformatted index? 
I built a centrifuge index consisted by COX1 genes downloaded from NCBI protein database (downloaded as CDS). COX1 is a home-keeping gene in all eukaryotic organisms so it should work well with most taxa to profile. COX1 is about 300 to 500 aa in length, which is much much less than the whole eukaryotic genomes or NT database (which has been preformatted by Centrifuge it self), and therefore it can work very efficiently (about 20 to 60 minutes per metagenomic sample). 

how to use it?
1) decompress the index file and adding the path of files inside to the corresponding arguements of centrifuge_work.sh and/or searchbylineages.commands.v2.sh (note that this script is optional to use, it can fetch and sort centrifuge results by the taxa or taxonomic levels you want)

gzip -d preset_cox1_index.tar.gz 

2) prepare a taxanames.txt file (still optional, only if you want to use searchbylineages.commands.v2.sh)
downloading taxdump.tar.gz from ftp://ftp.ncbi.nih.gov/pub/taxonomy/taxdump.tar.gz, and use the following codes, it may take some time

tar -xvf taxdump.tar.gz
grep "scientific name" taxdump/names.dmp | cut -f1,3 > taxanames.txt

finally, adding the full path of taxanames.txt to searchbylineages.commands.v2.sh and any other scripts you want to use
