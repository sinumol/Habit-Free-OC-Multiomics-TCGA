############################################
# DNA methylation analysis (Level 3 beta)
# Habit-free TCGA Oral Cancer
############################################
##Created on 07-12-2025

suppressMessages({
  library(dplyr)
  library(readr)
})

# -------------------------------
# Input & output (Snakemake)
# -------------------------------
beta_file <- snakemake@input[["beta"]]
anno_file <- snakemake@input[["annotation"]]
output_file <- snakemake@output[[1]]

# -------------------------------
# Read data
# -------------------------------
beta <- read_tsv(beta_file, col_types = cols())
anno <- read_tsv(anno_file, col_types = cols())

# Expect:
# beta: Probe_ID | Beta_Tumor | Beta_Normal
# anno: Probe_ID | Gene

meth <- beta %>%
  left_join(anno, by = "Probe_ID") %>%
  group_by(Gene) %>%
  summarise(
    Delta_Beta = mean(Beta_Tumor - Beta_Normal, na.rm = TRUE)
  ) %>%
  mutate(
    Methylation_Status = case_when(
      Delta_Beta >= 0.2  ~ "Hyper",
      Delta_Beta <= -0.2 ~ "Hypo",
      TRUE               ~ "No_change"
    )
  ) %>%
  select(Gene, Methylation_Status)

# -------------------------------
# Write output
# -------------------------------
write_tsv(meth, output_file)

message("Methylation analysis completed successfully")
