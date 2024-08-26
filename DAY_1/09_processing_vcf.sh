#!/bin/bash

# Description:
# This script performs several critical steps to process variant call format (VCF) files,
# including normalization of VCF data, and handling missing data, Phred scores, and indels. 
# These steps are essential for preparing
# high-quality VCF files for downstream analyses and ensuring consistency across the data.

# Step 1: Normalize VCF Data
# Normalization is performed to ensure that the VCF file adheres to standard formats. This includes
# canonicalizing indel representations, splitting multiallelic records, and ensuring consistent 
# reference sequences. `bcftools norm` is used to perform these normalization tasks.

# Path to the reference genome file
ref=/path/to/reference

# Normalize the VCF file
bcftools norm --check-ref w -f $ref/reference.fa -o norm.vcf.gz -Oz --threads file.vcf.gz

# Note:
# - Normalization with `bcftools norm` ensures that the VCF file is standardized and corrects any
#   discrepancies related to reference alleles and indel representations.
# - Handling of missing data and Phred scores should be addressed during variant calling and
#   normalization steps to ensure high data quality.
# - Indels (insertions and deletions) are specifically handled during normalization to ensure proper
#   representation in the VCF file.

# Step 2: Filter the Normalized VCF File with vcftools
# This step applies initial filtering to the normalized VCF file, including removing indels, restricting
# to biallelic SNPs, and applying quality and depth thresholds.

vcftools --gzvcf norm.vcf.gz \
--remove-indels \  # Remove indels from the VCF file
--min-alleles 2 \  # Require at least 2 alleles (i.e., only biallelic SNPs)
--max-alleles 2 \  # Limit to 2 alleles
--mac 3 \  # Minimum allele count across all samples
--minQ 30 \  # Minimum quality score (Phred-scaled)
--min-meanDP 3 \  # Minimum mean read depth across all samples
--max-missing 1 \  # Exclude variants with missing data in all samples
--recode \  # Output the filtered VCF file in standard format
--recode-INFO-all \  # Include all INFO fields in the output
--stdout | bgzip -@ 30 > 1_filter_norm.vcf.gz

# Step 4: Further Filter VCF File with bcftools
# This step applies additional gap-based filters to refine the VCF file, ensuring that only high-quality variants are retained.

bcftools filter --SnpGap 5 --IndelGap 5 --threads -Oz -o 2_filter_norm.vcf.gz 1_filter_norm.vcf.gz

# Note:
# - At the end of this process, one VCF file per chromosome/scaffold will be generated. 
# - Additional files may be created due to scaffolds (unassembled regions), which should be considered if they exceed 50 Mb (ideal: 100 Mb) to ensure representativeness.

echo "VCF preprocessing completed successfully"
