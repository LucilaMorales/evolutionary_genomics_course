#!/bin/bash

# Description:
# This script performs an eigenGWAS analysis, which is a method used to detect genetic variants 
# associated with eigenvectors (principal components) derived from population structure.
# The analysis is done using GEAR (Genome-wide Efficient Analysis of Regional variants) tool.

# Variables
BFILE=  # Path to the PLINK binary files (e.g., "/path/to/pca_pruned")
OUTDIR=  # Output directory (e.g., "/path/to/output")
EV=10  # Number of eigenvectors to compute

# Step 1: Create a Genetic Relationship Matrix (GRM)
java -jar -Xmx10G $GEAR/gear.jar grm --bfile $BFILE --out $OUTDIR/pca_pruned

# Step 2: Perform PCA to Compute Eigenvectors
java -jar -Xmx10G $GEAR/gear.jar pca --grm $OUTDIR/pca_pruned --ev $EV --out $OUTDIR/pca_pruned

# Step 3: Run EigenGWAS
# This step uses the eigenvectors generated in the previous step to perform a GWAS.
# --mpheno 1 specifies the eigenvector to be used for the analysis.

for i in $(seq 1 $EV); do
  java -jar -Xmx10G $GEAR/gear.jar egwas --bfile $BFILE --pheno $OUTDIR/pca_pruned.eigenvec \
  --mpheno $i --out $OUTDIR/egwas_pc$i
done
