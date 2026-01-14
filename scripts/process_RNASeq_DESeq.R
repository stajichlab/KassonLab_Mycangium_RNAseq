#!/usr/bin/env Rscript

library(DESeq2)
library(tximport)
library(dplyr)
library(ggplot2)
library(magrittr)
library(Biobase)
library(pheatmap)
library(RColorBrewer)
library(fdrtool)
library(geneplotter)
library(EDASeq)
library(tidyverse)
my_pal2 = mypal2 <- colorRampPalette(brewer.pal(6, "YlOrRd"))

countdata <- read.table("results/STAR_fungi_expression/Feuw_read_count.tsv", header=TRUE, row.names=1)

countdata <- countdata[ ,6:ncol(countdata)]
countdata <- as.matrix(countdata)
head(countdata)

samples <- read_csv("samples.csv",col_names=TRUE) %>% arrange(SAMPLE)
exprnames <- samples$SAMPLE
#exprnames <- sub("","",exprnames,perl=FALSE)

# check that experimental columns match in order
exprnames
fixnames = gsub("results.STAR_fungi.Feuw_","",colnames(countdata))
fixnames = gsub("Aligned.out.bam","",fixnames)
colnames(countdata) <- fixnames
all(exprnames %in% colnames(countdata))
all(exprnames == colnames(countdata))

all(exprnames == colnames(countdata))

# DEseq2 analyses
rep = factor( samples$replicate)
treatment = factor (samples$condition)

sampleTable <- data.frame(replicate = rep,
                          condition = treatment)
rownames(sampleTable) = exprnames

ddsAll <- DESeqDataSetFromMatrix(countData = countdata,
                              colData   = sampleTable, 
                              design    = ~ condition )
nrow(ddsAll)
dds <- ddsAll[ rowSums(counts(ddsAll)) > 1, ]
nrow(dds)
dds <- estimateSizeFactors(dds)
dds <- estimateDispersions(dds)

nrow(dds)
write_tsv(as_tibble(fpm(dds),rownames='TRANSCRIPT'), 'results/FPM.tsv')

rld <- rlog(dds, blind=FALSE)
nsb = sum(rowMeans(counts(dds, normalized=TRUE)) > 5)
vsd <- vst(dds, blind = TRUE, nsub = nsb)

#vsd <- vst(dds, blind=FALSE)
df <- bind_rows(as.data.frame(log2(counts(dds, normalized=TRUE)[, 1:2]+1)) %>%
    mutate(transformation = "log2(x + 1)"),
  as.data.frame(assay(rld)[, 1:2]) %>% mutate(transformation = "rlog"),
  as.data.frame(assay(vsd)[, 1:2]) %>% mutate(transformation = "vst"))

pdf("plots/RNASeq_sumplots.pdf")

#plotDispEsts(dds)

#multidensity( counts(dds, normalized = T),
#              xlab="mean counts", xlim=c(0, 1000))
#multiecdf( counts(dds, normalized = T),
#           xlab="mean counts", xlim=c(0, 1000))

#MA.idx = t(combn(1:4, 2))
#for( i in  seq_along( MA.idx[,1])){
#  MDPlot(counts(dds, normalized = T),
#         c(MA.idx[i,1],MA.idx[i,2]),
#         main = paste( colnames(dds)[MA.idx[i,1]], " vs ",
#                       colnames(dds)[MA.idx[i,2]] ), ylim = c(-3,3))
#}
select <- order(rowMeans(counts(dds,normalized=TRUE)),
                decreasing=TRUE)[1:50]
df2 <- as.data.frame(colData(dds)[,c("condition")])
rownames(df2) = colnames(countdata)
colnames(df2) = c("Treatment")

pheatmap(assay(vsd)[select,], cluster_rows=FALSE, show_rownames=TRUE,
         fontsize_row = 7,fontsize_col = 7,
         cluster_cols=FALSE, annotation_col=df2,main="VSD Top Expression")

topVar <- head(order(rowVars(assay(vsd)),
                     decreasing=TRUE),60)
mat  <- assay(vsd)[ topVar, ]
pheatmap(mat, show_rownames=TRUE,
         fontsize_row = 7,fontsize_col = 7,
         cluster_cols=FALSE, annotation_col=df2,main="VSD Most different")

pheatmap(assay(rld)[select,], cluster_rows=FALSE, show_rownames=TRUE,
         fontsize_row = 7,fontsize_col = 7,
         cluster_cols=FALSE, annotation_col=df2,main="RLD Top Expression")

pheatmap(assay(rld)[select,], cluster_rows=TRUE, show_rownames=TRUE,
         fontsize_row = 7,fontsize_col = 7,
         cluster_cols=FALSE, annotation_col=df2,main="RLD Top Expression")

sampleDists <- dist(t(assay(rld)))
sampleDistMatrix <- as.matrix(sampleDists)
rownames(sampleDistMatrix) <- paste(rld$condition,sep="-")
colnames(sampleDistMatrix) <- NULL
colors <- colorRampPalette( rev(brewer.pal(9, "Blues")) )(255)

pheatmap(sampleDistMatrix,
         clustering_distance_rows=sampleDists,
         clustering_distance_cols=sampleDists,
         col=colors)

pcaData <- plotPCA(rld, intgroup=c("condition","replicate"), returnData=TRUE)
percentVar <- round(100 * attr(pcaData, "percentVar"))

dev.off()

p<- ggplot(pcaData, aes(PC1, PC2, color=treatment,label=treatment)) +
  geom_point(size=3) +
  xlab(paste0("PC1: ",percentVar[1],"% variance")) +
  ylab(paste0("PC2: ",percentVar[2],"% variance")) +
  coord_fixed() + theme_bw()
ggsave("plots/PCA_expression.pdf",p)




