#!/bin/bash


maxBatch=20 # Should be 20
maxRep=5 # Should be 5
maxSub=1 # Should be 3

# Puts information calculated in R into a csv for each analysis for each gene
# This produces the csv file used to make the summary figures that show the effect of 
# the size of the tree on inferences
  for gene in nef tat p17 C1V2
  do
	  echo batch,rep,sub,sampleSize,intercept,slope,correlation,latentTime,RMSE,bias,coverageProb,CISize,MSE > plotsSS/${gene}_LS
	  echo batch,rep,sub,sampleSize,intercept,slope,correlation,latentTime,RMSE,bias,coverageProb,CISize,MSE > plotsSS/${gene}_LR
	  echo batch,rep,sub,sampleSize,intercept,slope,correlation,latentTime,RMSE,bias,MSE > plotsSS/${gene}_ML
	  echo batch,rep,sub,sampleSize,intercept,slope,correlation,latentTime,RMSE,bias,coverageProb,CISize,MSE > plotsSS/${gene}_Bayes
	  
      for ((rep=1;rep<=maxRep;rep++));
      do
        for ((sub=1;sub<=maxSub;sub++));
        do
          for ((batch=1;batch<=maxBatch;batch++));
          do
		  for sampleSize in 10 15 20 
		  do
		name=b${batch}r${rep}s${sub}${gene}S${sampleSize}
		dir=summarySS

		# LS method
		regression=$(tail -2 ${dir}/${name}summaryLS | head -1)
		correlation=$(grep Correlation ${dir}/${name}summaryLS | awk '{ print $3 }' | sed 's/"//g')
		means=$(tail -n +4 ${dir}/${name}summaryLS| head -1 )

		echo ${batch},${rep},${sub},${sampleSize},${regression},${correlation},${means}>> plotsSS/${gene}_LS

		# LR method
		regression=$(tail -2 ${dir}/${name}summaryLR | head -1)
		correlation=$(grep Correlation ${dir}/${name}summaryLR | awk '{ print $3 }' | sed 's/"//g')
		means=$(tail -n +4 ${dir}/${name}summaryLR| head -1 )

		echo ${batch},${rep},${sub},${sampleSize},${regression},${correlation},${means}>> plotsSS/${gene}_LR


		# ML method
		regression=$(tail -2 ${dir}/${name}summaryML | head -1)
		correlation=$(grep Correlation ${dir}/${name}summaryML | awk '{ print $3 }' | sed 's/"//g')
		means=$(tail -n +4 ${dir}/${name}summaryML| head -1 )

	 	echo ${batch},${rep},${sub},${sampleSize},${regression},${correlation},${means}>> plotsSS/${gene}_ML

		if [ $gene == p17 ] && [ $sampleSize != 10 ];
                then
		regression=$(tail -2 ${dir}/${name}summaryBayes | head -1)
		correlation=$(grep Correlation ${dir}/${name}summaryBayes | awk '{ print $3 }' | sed 's/"//g')
		means=$(tail -n +4 ${dir}/${name}summaryBayes| head -1 )

		echo ${batch},${rep},${sub},${sampleSize},${regression},${correlation},${means}>> plotsSS/${gene}_Bayes

		fi
	done
       	done
      done
      wait $!
    done
    sed -i 's/"//g' plotsSS/${gene}_LS
    sed -i 's/  / /g' plotsSS/${gene}_LS
    sed -i 's/ /,/g' plotsSS/${gene}_LS
    sed -i 's/,,/,/g' plotsSS/${gene}_LS

    sed -i 's/"//g' plotsSS/${gene}_LR
    sed -i 's/  / /g' plotsSS/${gene}_LR
    sed -i 's/ /,/g' plotsSS/${gene}_LR
    sed -i 's/,,/,/g' plotsSS/${gene}_LR

    sed -i 's/"//g' plotsSS/${gene}_ML
    sed -i 's/  / /g' plotsSS/${gene}_ML
    sed -i 's/ /,/g' plotsSS/${gene}_ML
    sed -i 's/,,/,/g' plotsSS/${gene}_ML


if [ $gene == p17 ];
then
    sed -i 's/"//g' plotsSS/${gene}_Bayes
    sed -i 's/  / /g' plotsSS/${gene}_Bayes
    sed -i 's/ /,/g' plotsSS/${gene}_Bayes
    sed -i 's/,,/,/g' plotsSS/${gene}_Bayes
fi
  done
