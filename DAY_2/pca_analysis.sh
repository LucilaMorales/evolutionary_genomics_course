#!/bin/bash

# Description:
# This script performs Principal Component Analysis (PCA) using PLINK. 
# PCA is a statistical technique that reduces the dimensionality of a dataset, 
# highlighting the most important variations and enabling visualization of data structure. 
# In genetics, PCA is used to identify patterns of genetic variation within populations.

# Tool:
# PLINK is a widely used tool in genetics for genotype data analysis. 
# In this script, PLINK is used to filter SNPs, generate binary files, 
# and perform PCA.

# Variables
VCF=  # Path to the VCF file containing the genotype data (e.g., "/path/to/file.vcf")

# Step 1: Prune SNPs for PCA
# This step filters out SNPs with high linkage disequilibrium (LD) to avoid over-representation 
# of certain haplotypes in the PCA analysis. The indep-pairwise method is used with a 
# window size of 50 SNPs, a step size of 10 SNPs, and an r^2 threshold of 0.1.

plink --vcf $VCF --double-id --allow-extra-chr \
--indep-pairwise 50 10 0.1 --out pca

# Step 2: Create Binary PLINK Files
# This step generates a set of binary files from the original VCF file, 
# using only the SNPs selected in the previous step (pca.prune.in). 
# These binary files (BED, BIM, FAM) are necessary to perform the PCA.

plink --vcf $VCF --double-id --allow-extra-chr --extract pca.prune.in --make-bed --out pca_pruned

# Step 3: Perform PCA
# In this step, PCA is performed using the binary files generated in the previous step. 
# The PCA results are saved in an output file (pca_results.eigenvec) that contains the coordinates 
# of the individuals in the principal component space.

plink --bfile pca_pruned --pca --allow-extra-chr --out pca_results

# Note:
# - The "pca_results.eigenvec" file contains the coordinates of each individual in the principal components.
# - The "pca_results.eigenval" file contains the eigenvalues associated with each principal component.
# - The PCA results can be visualized later in R or Python to identify clustering patterns among individuals or populations.
