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
rsem-gff3-to-gtf --RNA-patterns mRNA,rRNA  Fusarium_oligoseptatum_NRRL_62579.gff Fusarium_oligoseptatum_NRRL_62579.fixed.gtf
perl -i -p -e 's/rna-gnl\|WGS:NKCK\|//' genome/Fusarium_oligoseptatum_NRRL_62579.fixed.gtf

curl -O https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/040/115/645/GCF_040115645.1_ASM4011564v1/GCF_040115645.1_ASM4011564v1_genomic.fna.gz
curl -O https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/040/115/645/GCF_040115645.1_ASM4011564v1/GCF_040115645.1_ASM4011564v1_genomic.gff.gz

ln -s GCF_040115645.1_ASM4011564v1_genomic.fna.gz Euwallacea_fornicatus_EFF26.fna.gz
ln -s GCF_040115645.1_ASM4011564v1_genomic.gff.gz Euwallacea_fornicatus_EFF26.gff.gz
