#!/usr/bin/bash -l
IN=GCA_003957675.1_FeuwUCR1854v2_genomic.gtf
OUT=GCA_003957675.1_FeuwUCR1854v2_genomic.fixed.gtf
grep -P "\texon\t" $IN | \
	perl -p -e 's/gnl\|WGS:MIKF\|//g; s/gene_id.+locus_tag \"([^\"]+)\";.+/gene_id "$1"/' > $OUT


