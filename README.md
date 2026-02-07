# Multi-omics Analysis of Habit-Free TCGA Oral Cancer

This repository contains a reproducible Snakemake-based workflow for the analysis of multi-omics data from habit-free TCGA oral cancer samples.

##Created on 23-12-2025
##Author :Sinumol George
## Overview
The pipeline performs independent analyses of:
- Somatic mutation data (MAF)
- RNA-seq gene expression data
- DNA methylation data (Level 3 beta values)
- Copy number variation (CNV) data

All analyses are executed in a modular and reproducible manner using Snakemake and R scripts.

## Workflow
Each omics layer is processed using a dedicated R script, coordinated through a Snakemake workflow. The outputs can be interpreted jointly to study genes and pathways altered across multiple molecular layers in habit-free oral cancer.

## Requirements
- Snakemake
- R (≥ 4.0)
- R packages: maftools, dplyr, readr

## Usage
From the repository root directory, run:
```bash
snakemake --cores 4
