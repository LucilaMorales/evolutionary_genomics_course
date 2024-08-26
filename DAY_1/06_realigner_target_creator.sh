#!/bin/bash

# Description:
# This script creates realignment target intervals for BAM files using GATK's RealignerTargetCreator.
# Realignment is a crucial step in the preprocessing pipeline to correct misaligned reads
# caused by insertions and deletions (indels) in the reference genome. By identifying and
# creating target intervals where realignment is needed, the script helps improve the accuracy
# of variant calling and reduces potential artifacts caused by misaligned reads.

# Tool:
# GATK's RealignerTargetCreator is used to identify regions in BAM files that need to be realigned
# due to potential misalignment caused by indels. The tool generates a list of intervals (in the form 
# of a .intervals file) where realignment should be performed, which will be used in the subsequent 
# step of the realignment process.

# Variables
ref=  # Path to the reference genome fasta file (e.g., "/path/to/reference/reference.fna")
bam=  # Directory containing the BAM files with duplicates marked (e.g., "/path/to/dedup_bam")
files="sample1 sample2 sample3 sample4 sample5 sample6"  # List of sample names (without file extensions)

# Create Realignment Target Intervals
# The following loop iterates through each sample and runs GATK's RealignerTargetCreator 
# to generate target intervals for realignment. The command specifies the reference genome, 
# input BAM file, and output intervals file. The `-nt` option sets the number of threads, 
# and `-Xmx` specifies the memory allocated for the JVM.

for sample in $files; do
  gatk -nt -T RealignerTargetCreator -Xmx20G \
  -R $ref/reference.fna \
  -I $bam/${sample}_dedup.bam \
  -o $bam/${sample}.realn.intervals \
  -allowPotentiallyMisencodedQuals \
  -S LENIENT
  
  echo "Realignment target intervals created for $sample"
done

echo "Realignment target intervals creation completed for all samples"
