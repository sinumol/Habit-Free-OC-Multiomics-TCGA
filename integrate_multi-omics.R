library(dplyr)

maf <- read.csv("results/maf/driver_genes.csv")
deg <- read.csv("results/rnaseq/DEG_significant.csv")
meth <- read.csv("results/methylation/DMG.csv")
cnv <- read.csv("results/cnv/CNV_genes.csv")

all_genes <- Reduce(union, list(maf$Gene, deg$Gene, meth$Gene, cnv$Gene))

integration <- data.frame(Gene = all_genes) %>%
  mutate(
    Mutation = Gene %in% maf$Gene,
    Expression = Gene %in% deg$Gene,
    Methylation = Gene %in% meth$Gene,
    CNV = Gene %in% cnv$Gene
  ) %>%
  mutate(Multi_hit = Mutation + Expression + Methylation + CNV)

write.csv(integration,
          "results/integration/multiomics_summary.csv",
          row.names = FALSE)
