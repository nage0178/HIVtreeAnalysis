#!/bin/bash


# Creates the control files to run the MCMCs under the prior
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

				cp mcmctree/${name}_1.ctl mcmctree/${name}Prior_1.ctl
				cp mcmctree/${name}_2.ctl mcmctree/${name}Prior_2.ctl
				mkdir mcmctree/${name}Prior_1
				mkdir mcmctree/${name}Prior_2

				sed -i 's/usedata = 1/usedata = 0/g' mcmctree/${name}Prior_1.ctl
				sed -i 's/usedata = 1/usedata = 0/g' mcmctree/${name}Prior_2.ctl

			fi 
		done
	done
done

