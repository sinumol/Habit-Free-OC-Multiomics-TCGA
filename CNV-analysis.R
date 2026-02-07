############################################
# CNV analysis (gene-level)
# Habit-free TCGA Oral Cancer
############################################

suppressMessages({
  library(dplyr)
  library(readr)
})

# -------------------------------
# Input & output (Snakemake)
# -------------------------------
cnv_file <- snakemake@input[["cnv"]]
output_file <- snakemake@output[[1]]

# -------------------------------
# Read data
# -------------------------------
cnv <- read_tsv(cnv_file, col_types = cols())

# Expect:
# Gene | Segment_Mean

cnv_status <- cnv %>%
  mutate(
    CNV_Status = case_when(
      Segment_Mean >= 0.3  ~ "Gain",
      Segment_Mean <= -0.3 ~ "Loss",
      TRUE                 ~ "Neutral"
    )
  ) %>%
  select(Gene, CNV_Status)

# -------------------------------
# Write output
# -------------------------------
write_tsv(cnv_status, output_file)

message("CNV analysis completed successfully")
