############################################
# Habit-free TCGA Multi-Omics Pipeline
# MAF + RNA-seq + Methylation + CNV
############################################

configfile: "config/config.yaml"

rule all:
    input:
        "results/tables/gene_mutation_status.tsv",
        "results/tables/DEG_results.tsv",
        "results/tables/gene_methylation_status.tsv",
        "results/tables/gene_cnv_status.tsv",
        "results/tables/multiomics_integrated_results.tsv"

############################################
# 1. Somatic mutation analysis (MAF)
############################################
rule process_maf:
    input:
        maf="data/maf/{cohort}.maf"
    output:
        "results/tables/gene_mutation_status.tsv"
    script:
        "scripts/maf_analysis.R"

############################################
# 2. RNA-seq analysis
############################################
rule process_rnaseq:
    input:
        expr="data/rnaseq/expression_matrix.tsv",
        meta="data/rnaseq/sample_metadata.tsv"
    output:
        "results/tables/DEG_results.tsv"
    script:
        "scripts/rnaseq_analysis.R"

############################################
# 3. DNA methylation analysis (Level 3 beta)
############################################
rule process_methylation:
    input:
        beta="data/methylation/beta_values.tsv",
        annotation="data/methylation/annotation.tsv"
    output:
        "results/tables/gene_methylation_status.tsv"
    script:
        "scripts/methylation_analysis.R"

############################################
# 4. CNV analysis
############################################
rule process_cnv:
    input:
        cnv="data/cnv/gene_level_cnv.tsv"
    output:
        "results/tables/gene_cnv_status.tsv"
    script:
        "scripts/cnv_analysis.R"

############################################
# 5. Multi-omics integration
############################################
rule integrate_multiomics:
    input:
        mut="results/tables/gene_mutation_status.tsv",
        deg="results/tables/DEG_results.tsv",
        meth="results/tables/gene_methylation_status.tsv",
        cnv="results/tables/gene_cnv_status.tsv"
    output:
        "results/tables/multiomics_integrated_results.tsv"
    script:
        "scripts/integrate_multiomics.R"
