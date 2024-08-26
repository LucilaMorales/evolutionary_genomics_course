#!/bin/bash

# Description:
# This script generates a variant call format (VCF) file for a specific chromosome
# using `bcftools`. It performs variant calling based on the provided BAM files and reference genome,
# producing a VCF file that includes details on detected variants. The resulting VCF file is essential
# for downstream genetic analyses such as association studies, variant annotation, and population genetics.

# Tool:
# `bcftools` is a set of utilities that manipulate VCF and BCF files. In this script:
# - `mpileup` generates a pileup of sequence reads from the BAM files, which includes read depth and
#   potential variant sites.
# - `call` processes the pileup data to identify variants, creating a VCF file that lists the called variants.

# Variables
ref="/path/to/reference/reference.fa"  # Path to the reference genome fasta file
bam_list="bam_list"  # File containing a list of BAM files to include in the analysis
output_dir="/path/to/output_vcf"  # Directory where the VCF file will be saved

# Ensure the output directory exists
mkdir -p $output_dir

# Generate VCF File
# The following command uses `bcftools mpileup` to generate a pileup from the BAM files, followed by
# variant calling with `bcftools call`. The output is compressed and saved.

bcftools mpileup -Ou -f $ref -b $bam_list -d 5000 -q 10 -Q 30 -a "FORMAT/AD,FORMAT/DP,INFO/AD" --skip-indels --rf 2 | \
bcftools call -f GQ -vm -Oz -o $output_dir/file.vcf.gz

# Explanation:
# - `-f $ref`: Specifies the reference genome file.
# - `-b $bam_list`: Uses the list of BAM files for input.
# - `-d 5000`: Limits the maximum read depth to 5000 to prevent excessive computation and potential artifacts.
# - `-q 10`: Sets the minimum mapping quality for reads to be included.
# - `-Q 30`: Sets the minimum base quality for bases to be considered.
# - `-a "FORMAT/AD,FORMAT/DP,INFO/AD"`: Annotates the VCF with allele depth (AD) and read depth (DP) information.
# - `--skip-indels`: Excludes indels (insertions and deletions) from the analysis.
# - `--rf 2`: Filters reads based on bitwise flag 2 (e.g., properly paired reads in Illumina data).
# - `-f GQ`: Filters output by Genotype Quality.
# - `-vm`: Uses the multiallelic caller to consider multiple alternative alleles at sites.
# - `-Oz`: Outputs the VCF in compressed format (VCF.GZ).

echo "VCF generation completed"

# Note:
# The output VCF file (`file.vcf.gz`) will contain all the variants identified in the specified chromosome
# across the input BAM files. This VCF file is essential for subsequent genetic analysis.
