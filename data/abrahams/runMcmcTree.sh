#!/bin/bash


# For each batch (this is naming for tree simualation)

for file in 217_ENV2 217_ENV3 217_ENV4 257_ENV2 257_ENV3 257_ENV4 257_GAG1 257_NEF1
do
        # For each number of sequences subsampled
        for numSub in 10 15 20
        do
                # For each level of gap stripping
                for filter in 0.75 0.85 0.95
                do
                        name=${file}_d${numSub}_${filter}
                        if test -f "/home/anna/HIV_latency_general/data/abrahams/raxml/${name}.raxml.bestTree"; then

				cd  ~/HIV_latency_general/data/abrahams/mcmctree/${name}_1
				~/mcmctl/./mcmctree ../${name}_1.ctl &> output &

				cd ~/HIV_latency_general/data/abrahams/mcmctree/${name}_2
				~/mcmctl/./mcmctree ../${name}_2.ctl &> output &

			fi 
		done
	done
done

wait;
