#!/bin/bash


maxBatch=20 #20 # Should be 20
maxRep=5 # Should be 5
maxSub=3 # Should be 3

# Puts information calculated in R into a csv for each analysis for each gene
# This produces the final csv used to make the summary figure for the analysis 
# of the main simulated data
  for gene in nef tat p17 C1V2
  do
          echo batch,rep,sub,intercept,slope,correlation,latentTime,MSE,bias,coverageProb,CISize >plots/${gene}_LS
          echo batch,rep,sub,intercept,slope,correlation,latentTime,MSE,bias>plots/${gene}_ML
          echo batch,rep,sub,intercept,slope,correlation,latentTime,MSE,bias,coverageProb,CISize >plots/${gene}_LR
          echo batch,rep,sub,intercept,slope,correlation,latentTime,MSE,bias,coverageProb,CISize >plots/${gene}_Bayes
          
      for ((rep=1;rep<=maxRep;rep++));
      do
        for ((sub=1;sub<=maxSub;sub++));
        do
          for ((batch=1;batch<=maxBatch;batch++));
          do
        	name=b${batch}r${rep}s${sub}${gene}

        	# LS method
        	regression=$(tail -2 summary/${name}summaryLS | head -1)
        	correlation=$(grep Correlation summary/${name}summaryLS | awk '{ print $3 }' | sed 's/"//g')
        	means=$(tail -n +4 summary/${name}summaryLS| head -1 )

        	echo ${batch},${rep},${sub},${regression},${correlation},${means}>> plots/${gene}_LS

        	# ML  method
        	regressionND=$(tail -2 summary/${name}summaryML | head -1)
        	correlationND=$(grep Correlation summary/${name}summaryML | awk '{ print $3 }' | sed 's/"//g')
        	meansND=$(tail -n +4 summary/${name}summaryML | head -1 )

        	echo ${batch},${rep},${sub},${regressionND},${correlationND},${meansND}>> plots/${gene}_ML

        	#LR  
        	regressionLR=$(tail -2 summary/${name}summaryLR | head -1)
        	correlationLR=$(grep Correlation summary/${name}summaryLR | awk '{ print $3 }' | sed 's/"//g')
        	meansLR=$(tail -n +4 summary/${name}summaryLR | head -1 )

        	echo ${batch},${rep},${sub},${regressionLR},${correlationLR},${meansLR}>> plots/${gene}_LR

        	#Bayes 
        	
        	regressionBayes=$(tail -2 summary/${name}summaryBayes | head -1)
        	correlationBayes=$(grep Correlation summary/${name}summaryBayes | awk '{ print $3 }' | sed 's/"//g')
        	meansBayes=$(tail -n +4 summary/${name}summaryBayes | head -1 )

        	echo ${batch},${rep},${sub},${regressionBayes},${correlationBayes},${meansBayes}>> plots/${gene}_Bayes
       	done
      done
      wait $!
    done
    sed -i 's/"//g' plots/${gene}_LS
    sed -i 's/  / /g' plots/${gene}_LS
    sed -i 's/ /,/g' plots/${gene}_LS
    sed -i 's/,,/,/g' plots/${gene}_LS

    sed -i 's/"//g' plots/${gene}_ML
    sed -i 's/  / /g' plots/${gene}_ML
    sed -i 's/ /,/g' plots/${gene}_ML
    sed -i 's/,,/,/g' plots/${gene}_ML

    sed -i 's/"//g' plots/${gene}_LR
    sed -i 's/  / /g' plots/${gene}_LR
    sed -i 's/ /,/g' plots/${gene}_LR
    sed -i 's/,,/,/g' plots/${gene}_LR

    sed -i 's/"//g' plots/${gene}_Bayes
    sed -i 's/  / /g' plots/${gene}_Bayes
    sed -i 's/ /,/g' plots/${gene}_Bayes
    sed -i 's/,,/,/g' plots/${gene}_Bayes
  done
   # For some reason, R printed out the results on two lines for this run only, so the CI was not displayed. Fixing it manually since it was only a single run
    sed -i 's/10,5,1,0.03513,0.99285,0.899439861210082,4.92191780822,0.04284359032,-0.00008329228,0.89500000000/10,5,1,0.03513,0.99285,0.899439861210082,4.92191780822,0.04284359032,-0.00008329228,0.89500000000,3.72607187608/g' plots/nef_LS


# Puts information calculated in R into a csv for each analysis for each gene
echo batch,rep,sub,intercept,slope,correlation,latentTime,MSE,bias,coverageProb,CISize >plots/combine_Bayes
echo batch,rep,sub,intercept,slope,correlation,latentTime,MSE,bias,coverageProb,CISize >plots/combine_Bayes2
        
for ((rep=1;rep<=maxRep;rep++));
do
	for ((batch=1;batch<=maxBatch;batch++));
        do
		sub=1
	      	name=b${batch}r${rep}s${sub}combine
	
	      	#Bayes 
	      	
	      	regressionBayesC=$(tail -2 summary/${name}summaryBayesCombine | head -1)
	      	correlationBayesC=$(grep Correlation summary/${name}summaryBayesCombine | awk '{ print $3 }' | sed 's/"//g')
	      	meansBayesC=$(tail -n +4 summary/${name}summaryBayesCombine | head -1 )
	
      		echo ${batch},${rep},${sub},${regressionBayesC},${correlationBayesC},${meansBayesC}>> plots/combine_Bayes

	      	#Bayes 2
	      	
	      	regressionBayesC2=$(tail -2 summary/${name}summaryBayesCombine2 | head -1)
	      	correlationBayesC2=$(grep Correlation summary/${name}summaryBayesCombine2 | awk '{ print $3 }' | sed 's/"//g')
	      	meansBayesC2=$(tail -n +4 summary/${name}summaryBayesCombine2 | head -1 )
	
      		echo ${batch},${rep},${sub},${regressionBayesC2},${correlationBayesC2},${meansBayesC2}>> plots/combine_Bayes2
	done
done


sed -i 's/"//g' plots/combine_Bayes
sed -i 's/  / /g' plots/combine_Bayes
sed -i 's/ /,/g' plots/combine_Bayes
sed -i 's/,,/,/g' plots/combine_Bayes

sed -i 's/"//g' plots/combine_Bayes2
sed -i 's/  / /g' plots/combine_Bayes2
sed -i 's/ /,/g' plots/combine_Bayes2
sed -i 's/,,/,/g' plots/combine_Bayes2
