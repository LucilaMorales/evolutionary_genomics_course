#!/bin/bash

# Description:
# This script calculates various diversity indices using `vcftools`. 
# These indices provide insights into the genetic diversity within populations, 
# which is crucial for understanding population structure, evolutionary processes, and conservation biology.

# Tool:
# `vcftools` is a program package designed for working with VCF files, allowing users to filter, summarize, and analyze genetic data.
# In this script, we will calculate nucleotide diversity (π), Tajima's D, and observed heterozygosity.

# Variables
VCF=  # Path to the input VCF file (e.g., "/path/to/input.vcf.gz")
POP=  # Path to the file containing the list of individuals for each population (e.g., "population.txt")
OUTDIR=  # Directory where the results will be saved (e.g., "/path/to/output_dir")

# Step 1: Calculate Nucleotide Diversity (π)
# Nucleotide diversity is the average number of nucleotide differences per site between two randomly chosen DNA sequences from the sample population.

vcftools --gzvcf $VCF --keep $POP --site-pi --out $OUTDIR/nucleotide_diversity

# The results will be saved in a file named "nucleotide_diversity.sites.pi", 
# where each line represents a site and its corresponding nucleotide diversity.

# Step 2: Calculate Tajima's D
# Tajima's D is a statistical test used to identify regions of the genome that deviate from the neutral theory of evolution.

vcftools --gzvcf $VCF --keep $POP --TajimaD 10000 --out $OUTDIR/tajima_d

# The results will be saved in a file named "tajima_d.Tajima.D", 
# where each line represents a genomic window (e.g., 10 kb) and the corresponding Tajima's D value.

# Step 3: Calculate Observed Heterozygosity
# Observed heterozygosity is the proportion of heterozygous individuals in a population.

vcftools --gzvcf $VCF --keep $POP --het --out $OUTDIR/observed_heterozygosity

# The results will be saved in a file named "observed_heterozygosity.het", 
# containing information on the observed and expected number of heterozygous sites for each individual.

# Step 4: (Optional) Additional Diversity Indices
# You can also calculate other diversity indices such as Weir and Cockerham's Fst between populations, 
# allele frequencies, or inbreeding coefficients using similar `vcftools` commands.

# Example: Calculate Fst between two populations
POP1=  # Path to the file containing the list of individuals for population 1 (e.g., "pop1.txt")
POP2=  # Path to the file containing the list of individuals for population 2 (e.g., "pop2.txt")

vcftools --gzvcf $VCF --weir-fst-pop $POP1 --weir-fst-pop $POP2 --out $OUTDIR/fst_between_pop1_pop2

echo "Diversity indices calculation completed."

# Note:
# Ensure that the population files (`$POP`, `$POP1`, `$POP2`) are plain text files with one individual ID per line.
