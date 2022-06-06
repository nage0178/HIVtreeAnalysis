#!/bin/bash

rm -f mu.csv

echo gene,rep,outgroup,mu,mu_low,mu_high,alpha,alpha_low,alpha_high,kappa,kappa_low,kappa_high,T,C,A,G > mu.csv
for file in C1V2 nef p17 tat
do
  for rep in 1 2 3 4 5
  # for outgroup in CS2 1006 1018 PIC55751
  do
  og1=$(tail -n 4 ${file}_g15/CS2_${rep}/out.txt |head -1 |awk '{print $2, $4, $5}' |sed 's/,//g' | sed 's/)//g')
  alpha1=$(tail -n 2 ${file}_g15/CS2_${rep}/out.txt |head -1 |awk '{print $2, $4, $5}' |sed 's/,//g' | sed 's/)//g')
  kappa1=$(tail -n 3 ${file}_g15/CS2_${rep}/out.txt |head -1 |awk '{print $2, $4, $5}' |sed 's/,//g' | sed 's/)//g')
  stat1=$(grep Average ${file}_g15/CS2_${rep}/out.txt | awk '{print $2, $3, $4, $5}')

  og2=$(tail -n 4 ${file}_g15/1006_${rep}/out.txt |head -1 |awk '{print $2, $4, $5}' |sed 's/,//g' | sed 's/)//g')
  alpha2=$(tail -n 2 ${file}_g15/1006_${rep}/out.txt |head -1 |awk '{print $2, $4, $5}' |sed 's/,//g' | sed 's/)//g')
  kappa2=$(tail -n 3 ${file}_g15/1006_${rep}/out.txt |head -1 |awk '{print $2, $4, $5}' |sed 's/,//g' | sed 's/)//g')
  stat2=$(grep Average ${file}_g15/1006_${rep}/out.txt | awk '{print $2, $3, $4, $5}')

  og3=$(tail -n 4 ${file}_g15/1018_${rep}/out.txt |head -1 |awk '{print $2, $4, $5}' |sed 's/,//g' | sed 's/)//g')
  alpha3=$(tail -n 2 ${file}_g15/1018_${rep}/out.txt |head -1 |awk '{print $2, $4, $5}' |sed 's/,//g' | sed 's/)//g')
  kappa3=$(tail -n 3 ${file}_g15/1018_${rep}/out.txt |head -1 |awk '{print $2, $4, $5}' |sed 's/,//g' | sed 's/)//g')
  stat3=$(grep Average ${file}_g15/1018_${rep}/out.txt | awk '{print $2, $3, $4, $5}')

  og4=$(tail -n 4 ${file}_g15/PIC55751_${rep}/out.txt |head -1 |awk '{print $2, $4, $5}' |sed 's/,//g' | sed 's/)//g')
  alpha4=$(tail -n 2 ${file}_g15/PIC55751_${rep}/out.txt |head -1 |awk '{print $2, $4, $5}' |sed 's/,//g' | sed 's/)//g')
  kappa4=$(tail -n 3 ${file}_g15/PIC55751_${rep}/out.txt |head -1 |awk '{print $2, $4, $5}' |sed 's/,//g' | sed 's/)//g')
  stat4=$(grep Average ${file}_g15/PIC55751_${rep}/out.txt | awk '{print $2, $3, $4, $5}')


    echo ${file} ${rep} CS2 ${og1} ${alpha1} ${kappa1} ${stat1} >> mu.csv
    echo ${file} ${rep} 1006 ${og2} ${alpha2} ${kappa2} ${stat2} >> mu.csv
    echo ${file} ${rep} 1018 ${og3} ${alpha3} ${kappa3} ${stat3} >> mu.csv
    echo ${file} ${rep} PIC55751 ${og4} ${alpha4} ${kappa4} ${stat4} >> mu.csv
done

done
sed -i 's/ /,/g' mu.csv

Rscript parameter_est.R

sed -i 's/"//g' parameter_est.csv
sed -i 's/ //g' parameter_est.csv

cp parameter_est.csv ~/HIVtreeAnalysis/dnaSimulations/ref_seq/ .
