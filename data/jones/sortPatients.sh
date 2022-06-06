#!/bin/bash
rm -f p1_accession p2_accession p1_dates.csv p2_dates.csv

# Makes a file with all the accession numbers
grep ">" jones.fasta | awk '{print $1}' | sed 's/>//g' > accessionNum

# Makes a file with the lines that list the host
grep host= jones.gb -n > hostLine

# Makes a file with only the line numbers for the f_host
awk '{ print $1 }' hostLine | sed 's/://g' > hostLineOnly

grep date= jones.gb -n > dateLine
awk '{ print $1 }' dateLine | sed 's/://g' > dateLineOnly

grep isolation_source jones.gb -n > sourceLine
awk '{ print $1 }' sourceLine | sed 's/://g' > sourceLineOnly


# Separates into two patients
# Creates a csv file for both patients in the correct format for the jones LR analysis
python sortPatients.py

rm -f accessionNum p1_accession p2_accession  p1_toAlign.fa hostLine hostLineOnly dateLine dateLineOnly sourceLine sourceLineOnly

sed -i 's/ .*//g' p1_alignment.fa
sed -i 's/ .*//g' p2_alignment.fa
sed -i 's/ .*//g' p1_alignment_date.fa
sed -i 's/ .*//g' p2_alignment_date.fa
