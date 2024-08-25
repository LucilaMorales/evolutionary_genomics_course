#!/bin/bash

# Description:
# This script generates variant call format (VCF) files from BAM files using `bcftools`.
# The script performs variant calling on each specified chromosome, producing VCF files
# that contain information about variants across the specified regions. This step is essential
# for identifying genetic variations in the samples, which are crucial for downstream analyses
# such as association studies and genomic annotations.

# Tool:
# `bcftools` is a set of tools for manipulating VCF and BCF files. In this script:
# - `mpileup` is used to generate pileup data from BAM files, which contains read depth and variant
#   information.
# - `call` is used to perform variant calling and generate the VCF file from the pileup data.

# Variables
chromosome_list=  # File containing a list of chromosomes or regions to process (e.g., "chromosomes.txt")
bam_list=  # File containing a list of BAM files to include in the analysis (e.g., "bam_list.txt")
ref=  # Path to the reference genome fasta file (e.g., "/path/to/reference/reference.fna")
output_dir=  # Directory where the VCF files will be saved (e.g., "/path/to/output_vcf")

# Generate VCF Files
# The following command reads each chromosome or region from the chromosome_list file,
# and for each chromosome, it generates a VCF file using `bcftools`. The command:
# - Uses `bcftools mpileup` to create a pileup of reads from the BAM files.
# - Calls variants using `bcftools call`.
# - Compresses the resulting VCF file using gzip.

cat $chromosome_list | \
xargs -I {} -n 1 -P 4 sh -c 'bcftools mpileup -Ou -f $ref -b $bam_list -d 5000 -q 10 -Q 30 -a "FORMAT/AD,FORMAT/DP,INFO/AD" --skip-indels -r {} --rf 2 | \
bcftools call -f GQ -vm -Oz -o $output_dir/{}.vcf.gz' 

echo "VCF generation completed for all chromosomes"

# Note:
# At the end of this process, one VCF file will be generated per chromosome of the reference genome.
# Additionally, files may be generated for scaffold regions (unassembled regions). To ensure these
# files are representative, scaffold regions should be larger than 50 Mb (ideally 100 Mb)
