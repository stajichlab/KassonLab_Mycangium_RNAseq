#!/usr/bin/bash -l
#SBATCH -c 64 --mem 256gb --out logs/kraken2.%a.log

CPU=$SLURM_CPUS_ON_NODE
N=1
if [ ! -z $SLURM_ARRAY_TASK_ID ]; then
	N=$SLURM_ARRAY_TASK_ID
elif [ ! -z $1 ]; then
	N=$1
fi
module load kraken2

OUT=results/kraken2
IN=results/bbpslit
mkdir -p $OUT

DBFOLDER=/srv/projects/db/kraken2
for DBNAME in pluspfp viral standard
do
	DB=$DBFOLDER/$DBNAME
	IFS=,
	tail -n +2 samplesheet.csv | sed -n ${N}p | while read ID LEFT RIGHT STRAND
	do
		if [ -s $OUT/${ID}.${DBNAME}.k2report ]; then
			echo "$ID.${DBNAME}.k2report output exists, skipping"
			continue
		fi
		kraken2 --db $DB  --report $OUT/${ID}.$DBNAME.k2report --report-minimizer-data --minimum-hit-groups 2 --gzip-compressed --threads 24 $IN/${ID}_unmapped.fq.gz > $OUT/${ID}.$DBNAME.kraken2
	done
	unset IFS
done