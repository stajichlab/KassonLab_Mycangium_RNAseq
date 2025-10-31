#!/usr/bin/bash -l

TARGET=input
SOURCE=reads
IFS=$'\n'
mkdir -p $TARGET
echo "sample,fastq_1,fastq_2,strandedness,devstage" > samplesheet.csv
for a in $(find $SOURCE -type f -name "*.fastq.gz"); do
    b=$(basename $a)
    c=$(echo "$b" | perl -p -e 's/Copy of Kasson-McKeon_//;')
    ln -s "../${a}" $TARGET/$c
    if [[ $c == *_R1_*.fastq.gz ]]; then
        R1=$c
        sampid=$(basename $c _L001_R1_001.fastq.gz)
        sampid=$(echo $sampid | perl -p -e 's/_S\d+$//;')
        R2=$(echo $c | perl -p -e 's/_R1_/_R2_/;')
        devstage=$(echo $sampid | perl -p -e 's/Mycangia_//;')
        echo "$sampid,${TARGET}/$R1,${TARGET}/$R2,auto,$devstage" >> samplesheet.csv
    fi
done