#!/bin/bash

# Description:
# This script sorts the mapped BAM files produced from the previous mapping step. 
# Sorting is an important preprocessing step before further analyses such as variant calling 
# or visualization. Sorted BAM files ensure that reads are ordered by their genomic coordinates, 
# which is essential for efficient and accurate processing by downstream tools.

# Tool:
# We use 'samtools' for sorting the BAM files. Samtools is a suite of programs for interacting 
# with high-throughput sequencing data, and sorting is one of the fundamental operations 
# that prepares BAM files for subsequent analysis. Sorted BAM files are required for many 
# downstream applications, including variant callers and visualization tools.

# Variables
bam=  # Directory containing the input BAM files (e.g., "/path/to/bam")
files="sample1 sample2 sample3"  # List of sample names (without file extensions)

# Sorting BAM Files
# The following loop iterates through each sample and sorts the corresponding BAM file.
# - The `-@` option specifies the number of threads to use for sorting.
# - The output file will be saved with the suffix "_sorted.bam" in the same directory.

for sample in $files; do
  samtools sort -@ 4 \
  -o $bam/${sample}_sorted.bam \
  $bam/${sample}.bam
  
  echo "Sorting completed for $sample"
done

echo "All BAM files sorted successfully."

