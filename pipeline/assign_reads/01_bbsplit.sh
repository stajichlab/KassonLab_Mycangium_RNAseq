#!/usr/bin/bash -l
#SBATCH -p short -c 48 --mem 96gb --out logs/bbsplit_run.%a.log

CPU=$SLURM_CPUS_ON_NODE
module load BBMap
mkdir -p split
#bbsplit.sh build=1 ref_Efor=beetle/GCF_040115645.1_ASM4011564v1_genomic.fna ref_Esim=beetle/GCF_039881205.1_ESF131.1_genomic.fna ref_Feuw=alt_fungi/GCA_002168265.2_ASM216826v2_genomic.fna ref_Rdelt=alt_fungi/GCA_019925385.1_ASM1992538v1_genomic.fna ref_Ralb=alt_fungi/GCA_002778245.1_ASM277824v1_genomic.fna ref_Rarx=alt_fungi/GCA_002778165.1_ASM277816v1_genomic.fna
N=1
if [ ! -z $SLURM_ARRAY_TASK_ID ]; then
	N=$SLURM_ARRAY_TASK_ID
elif [ ! -z $1 ]; then
	N=$1
fi

DB=db
OUT=results/bbpslit
mkdir -p $DB $OUT
# beetles
ln -s $(realpath beetle/GCF_039881205.1_ESF131.1_genomic.fna) $DB/Esim.fa
ln -s $(realpath beetle/GCF_040115645.1_ASM4011564v1_genomic.fna) $DB/Efor.fa
# fungi
ln -s $(realpath alt_fungi/GCA_002168265.2_ASM216826v2_genomic.fna) $DB/Feuw.fa
ln -s $(realpath alt_fungi/GCA_003946995.1_NRRL62579.SPAdes_genomic.fna) $DB/Foligo.fa
ln -s $(realpath alt_fungi/GCA_019925385.1_ASM1992538v1_genomic.fna) $DB/Rdelt.fa
ln -s $(realpath alt_fungi/GCA_002778245.1_ASM277824v1_genomic.fna) $DB/Ralb.fa
ln -s $(realpath alt_fungi/GCA_002778165.1_ASM277816v1_genomic.fna) $DB/Rarx.fa
ln -s $(realpath alt_fungi/GCA_003946995.1_NRRL62579.SPAdes_genomic.fna) $DB/Rspad.fa
IN=$(ls db/*.fa | tr '\n' ',' | sed 's/,$//')

IFS=,
tail -n +2 samplesheet.csv | sed -n ${N}p | while read ID LEFT RIGHT STRAND
do
	unset IFS
	# might want to vary intron size here with maxindel=50k depending on largest intron
	if [ ! -f $OUT/${ID}_unmapped.fq.gz ]; then
		echo "Processing $ID"
		bbsplit.sh ref=$IN in=$LEFT in2=$RIGHT basename=$OUT/${ID}_%.fq.gz outu=$OUT/${ID}_unmapped.fq.gz threads=$CPU
	fi
	IFS=,
done