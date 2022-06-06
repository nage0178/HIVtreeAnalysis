# Makes a csv file in the format for the node dating analysis

inFile=$1
name=$2

# Finds all the sequence names without the outgroup
grep '>' ${inFile} | grep -v outgroup > seqNames_${name}

# First line of csv file
echo "FULLSEQID","COLDATE","CENSORED" > infoSS/${name}.csv

# For each sequence
for line in $(cat seqNames_${name})
do
  # Removes the ">" in front of the name
  seqNum=$(echo ${line} |sed 's/[>]//g')

  # Finds whether the sequence is latent and the sample date
  pat='Node_([0-1])_([0-9]*)_([0-9]*)_([0-9]*)'
  [[ "$seqNum" =~ $pat ]]
    latent=${BASH_REMATCH[1]}
    sampleDate=${BASH_REMATCH[4]}

    # Adds line to csv file for analysis
    echo \"${seqNum}\",${sampleDate},${latent} >> infoSS/${name}.csv

done
rm seqNames_${name}
