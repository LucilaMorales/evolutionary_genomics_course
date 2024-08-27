#!/bin/bash

# Description:
# This script performs an admixture analysis using ADMIXTURE. 
# Admixture analysis estimates the ancestry proportions of individuals in a sample, 
# revealing their genetic backgrounds and the degree of admixture between populations.

# Tool:
# ADMIXTURE is a software tool used for maximum likelihood estimation of individual ancestries 
# from multilocus SNP genotype datasets. It is similar to STRUCTURE but is more computationally efficient.

# Variables
BEDFILE=  # Path to the binary PLINK file (without extensions) (e.g., "/path/to/file_prefix")
K=  # Number of ancestral populations to infer (e.g., 3)

# Step 1: Run ADMIXTURE
# This command runs ADMIXTURE on the binary PLINK files generated earlier.
# ADMIXTURE expects .bed, .bim, and .fam files as input and requires you to specify the number of ancestral populations (K).

admixture --cv ${BEDFILE}.bed $K | tee ${BEDFILE}_K${K}.out

# Step 2: Cross-validation
# The `--cv` flag performs cross-validation to help you choose the most appropriate K value.
# The output file ("${BEDFILE}_K${K}.out") will contain the results, including the cross-validation error for each K.

# Note:
# - The `Q` file (e.g., "${BEDFILE}.Q") contains the ancestry proportions for each individual.
# - The `P` file (e.g., "${BEDFILE}.P") contains the allele frequencies in each inferred population.
# - The cross-validation errors can be compared to determine the best K value (the one with the lowest error).

# Step 3: Visualizing Results
# To visualize the Q-matrix (ancestry proportions), you can use the pophelper tool available at http://pophelper.com/.
# - pophelper provides an R package and a web tool for plotting and analyzing population structure results.
# - It generates bar plots where each individual is represented as a bar divided into K segments, each colored according to ancestry proportions.
