for vol in 5 10 20 30 40 50 60 70 80 90 100
do
	dir=~/../runCompareVolume/vol_${vol}/run
  ./compare_tree ${dir}1/SampledTree.txt ${dir}1/LatentStates.txt > compareVolume/${vol}_run1
  ./compare_tree ${dir}2/SampledTree.txt ${dir}2/LatentStates.txt > compareVolume/${vol}_run2
  ./compare_tree ${dir}3/SampledTree.txt ${dir}3/LatentStates.txt > compareVolume/${vol}_run3
  ./compare_tree ${dir}4/SampledTree.txt ${dir}4/LatentStates.txt > compareVolume/${vol}_run4
  ./compare_tree ${dir}5/SampledTree.txt ${dir}5/LatentStates.txt > compareVolume/${vol}_run5

  ./compare_tree ${dir}6/SampledTree.txt ${dir}6/LatentStates.txt > compareVolume/${vol}_run6
  ./compare_tree ${dir}7/SampledTree.txt ${dir}7/LatentStates.txt > compareVolume/${vol}_run7
  ./compare_tree ${dir}8/SampledTree.txt ${dir}8/LatentStates.txt > compareVolume/${vol}_run8
  ./compare_tree ${dir}9/SampledTree.txt ${dir}9/LatentStates.txt > compareVolume/${vol}_run9
  ./compare_tree ${dir}10/SampledTree.txt ${dir}10/LatentStates.txt > compareVolume/${vol}_run10


done

cd compareVolume
rm -f compare_volume.csv
touch compare_volume.csv
echo Volume, run, Tree_length, time_latent, percent_time_latent, root_age >> compare_volume.csv
for vol in 5 10 20 30 40 50 60 70 80 90 100
do
  for run in 1 2 3 4 5 6 7 8 9 10
  do
    length=$(grep "Tree Length" ${vol}_run${run} | grep -Eo "[0-9]+\.[0-9]+")
    totLatent=$(grep "Total time Latent" ${vol}_run${run} | grep -Eo "[0-9]+\.[0-9]+")
    percLatent=$(grep "Percent time latent" ${vol}_run${run} | grep -Eo "[0-9]+\.[0-9]+")
    rootAge=$(grep "Root age" ${vol}_run${run} | grep -Eo "[0-9]+\.[0-9]+")
    echo ${vol}, ${run}, ${length}, ${totLatent}, ${percLatent}, ${rootAge} >> compare_volume.csv
  done
done

Rscript compareVolumes.R
