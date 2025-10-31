#!/usr/bin/bash -l
#SBATCH -p epyc -n 1 -N 1 -c 24 --mem 192gb --out logs/nf.log --time 3-0:0:0

module load singularity
GENOME=genome/Fusarium_oligoseptatum_NRRL_62579.fasta
GTF=genome/Fusarium_oligoseptatum_NRRL_62579.fixed.gtf
GFF=genome/Fusarium_oligoseptatum_NRRL_62579.gff
mkdir -p results
nextflow run nf-core/rnaseq -resume -c ucr_hpcc.config -profile singularity \
    --input samplesheet.csv \
    --bbsplit_fasta_list bb_split_list.txt \
    --skip_bbsplit false \
    --outdir results/nf_rnaseq \
    --gtf $GTF \
    --fasta $GENOME \
    --star_rsem --save_unaligned \
    --minAssignedFrags 1 \
    --skip_pseudo_alignment

