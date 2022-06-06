#!/bin/bash

mkdir info

# For each patient
for pt in p1 p2
do
	# For each substituion model
        for analysis in HKY GTR
        do
		cp raxml/${pt}_${analysis}.raxml.bestTree trees/${pt}_${analysis}.nwk

                name=${pt}_${analysis}

		echo "ID","Date","Query" > info/${name}.csv

		# For each sequence
		for line in $(cat ${pt}_dates.csv)
		do

			pat='"(.*)","(.*)","(.*)",(.*),"(.*)",([0-1]),1,(.*),(.*)'
			# Check the line is in the correct format
			if [[ "$line" =~ $pat ]]; then
				seq=${BASH_REMATCH[2]}
				date=${BASH_REMATCH[4]}
				lat=${BASH_REMATCH[6]}

				# Add the sequence to the new csv file for the alternative jones linear regression methods
				echo ${seq},${date},${lat}>>info/${name}.csv

			else
				echo No match for ${line}
			fi

    
		done
	done
done
