mkdir statsLR
mkdir data
# For each patient
for pt in p1 p2
do
	# For each substitution model
        for analysis in HKY GTR
        do
		name=${pt}_${analysis}

		# Runs the alternative Jones linear regression analysis
		Rscript ~/phylodating/scripts/root_and_regress.R --runid ${name} --tree trees/${name}.nwk --rootedtree trees.rooted.rtt/${name}.rooted.nwk --info info/${name}.csv --stats statsLR/${name}.csv --data data/${name}.txt &> out${name}LR &

	done
done
wait
