#!/usr/bin/bash -l
#SBATCH -p short

mkdir -p genome

pushd genome
curl -O https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/003/946/995/GCA_003946995.1_NRRL62579.SPAdes/GCA_003946995.1_NRRL62579.SPAdes_genomic.fna.gz
curl -O https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/003/946/995/GCA_003946995.1_NRRL62579.SPAdes/GCA_003946995.1_NRRL62579.SPAdes_genomic.gff.gz
curl -O https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/003/946/995/GCA_003946995.1_NRRL62579.SPAdes/GCA_003946995.1_NRRL62579.SPAdes_genomic.gtf.gz
gunzip *.gz

ln -s GCA_003946995.1_NRRL62579.SPAdes_genomic.fna Fusarium_oligoseptatum_NRRL_62579.fasta
ln -s GCA_003946995.1_NRRL62579.SPAdes_genomic.gtf Fusarium_oligoseptatum_NRRL_62579.gtf
ln -s GCA_003946995.1_NRRL62579.SPAdes_genomic.gff Fusarium_oligoseptatum_NRRL_62579.gff
