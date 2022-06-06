mkdir raxml
# For each patient, run raxml under a HKY and GTR model
for pt in p1 p2
do
	raxml-ng --msa ${pt}_alignment_date.fa --prefix raxml/${pt}_HKY --model HKY+G --tree pars{25},rand{25} --seed 1 &> raxml/${pt}_HKY_raxmlOut &
	raxml-ng --msa ${pt}_alignment_date.fa --prefix raxml/${pt}_GTR --model GTR+G --tree pars{25},rand{25} --seed 2 &> raxml/${pt}_GTR_raxmlOut & 
done

wait
