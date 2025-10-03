#!/usr/bin/bash -l
#SBATCH -p epyc -n 1 -N 1 -c 24 --mem 192gb --out logs/nf.log --time 3-0:0:0

module load singularity
GENOME=genome/Fusarium_oligoseptatum_NRRL_62579.fasta
GFF=genome/Fusarium_oligoseptatum_NRRL_62579.gff
mkdir -p results
nextflow run nf-core/rnaseq \
    --input samplesheet.csv \
    --outdir results/nf_rnaseq \
    --gff $GFF \
    --fasta $GENOME \
    -profile singularity \
    --star_rsem --bam_csi_index --save_unaligned \
    -resume -c ucr_hpcc.config

#--gtf genome/GCA_022478985.1_UCR_MCPNR19_1.0_genomic.gtf \


