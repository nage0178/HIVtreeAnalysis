#!/bin/bash

batch=$1
if [ ! "$1" ]
  then
    echo No batch number was provided. Exiting.
    exit
fi

# Start part before checkpoint
if [ -z "$(ls|grep b${batch}r[1-9])" ]
  then
    #rm -f b${batch}pid
    for rep in {1..5}
    do
      ~/HIVtreeSimulations/treeSim/./HIV_treeSim -c ../runFiles/pt7.ctrl -o b${batch}r${rep} -t 60 -s ${batch}0${rep} &> b${batch}r${rep}out1 &
      echo "$!" >> b${batch}pid

    done


  # Wait to get through checkpoint for all jobs that were just started
  for pid in $(cat b${batch}pid)
  do
    wait $pid
  done

  # Reload after checkpoint
  for rep in {1..8}
  do
    ~/HIVtreeSimulations/treeSim/./HIV_treeSim  -l b${batch}r${rep} -o b${batch}r${rep}  &> b${batch}r${rep}out2 &
  done
else
  echo This batch number has already been used.
fi
