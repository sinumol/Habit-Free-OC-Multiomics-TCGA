############################################
# Somatic mutation analysis (MAF)
# Habit-free TCGA Oral Cancer
############################################

# Load libraries
suppressMessages({
  library(maftools)
  library(dplyr)
  library(readr)
})

# -------------------------------
# Input & output (from Snakemake)
# -------------------------------
maf_file   <- snakemake@input[[1]]
output_file<- snakemake@output[[1]]

# -------------------------------
# Read MAF file
# -------------------------------
maf <- read.maf(maf = maf_file)

# -------------------------------
# Extract gene-level mutation status
# -------------------------------
mutated_genes <- maf@data %>%
  select(Hugo_Symbol) %>%
  distinct() %>%
  mutate(Mutation_Status = 1) %>%
  rename(Gene = Hugo_Symbol)

# -------------------------------
# Optional: filter by mutation type
# (keep non-silent only)
# -------------------------------
# mutated_genes <- maf@data %>%
#   filter(Variant_Classification != "Silent") %>%
#   select(Hugo_Symbol) %>%
#   distinct() %>%
#   mutate(Mutation_Status = 1) %>%
#   rename(Gene = Hugo_Symbol)

# -------------------------------
# Write output
# -------------------------------
write_tsv(mutated_genes, output_file)

message("MAF processing completed successfully")
