simNum=$1
inFile=$2
name=$3
grep '>' ${inFile} > seqNames_${name}

# First line of csv file
echo "ID","Date","Query" > info/${simNum}.csv

# For each sequence
for line in $(cat seqNames_${name})
do
  seqNum=$(echo ${line} |sed 's/[>]//g')

  # Pattern to match
  pat='Node_([0-1])_([0-9]*)_([0-9]*)_([0-9]*)'
  [[ "$seqNum" =~ $pat ]]
    latent=${BASH_REMATCH[1]}
    sampleDate=${BASH_REMATCH[4]}

    # Adds line to csv file for Jones analysis
    echo ${seqNum},${sampleDate},${latent} >> info/${simNum}.csv

done
rm seqNames_${name}
