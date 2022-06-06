for outgroup in 1006 1018 CS2 PIC55751
do

	for file in C1V2 nef p17 tat
	do

		cp generic.ctl ${file}_${outgroup}_G15.ctl

		sed -i "s/C1V2.fa/${file}_${outgroup}_mcmc.fa/g" ${file}_${outgroup}_G15.ctl
		sed -i "s/C1V2.txt/${file}_strip_${outgroup}.txt/g" ${file}_${outgroup}_G15.ctl

	done
done
