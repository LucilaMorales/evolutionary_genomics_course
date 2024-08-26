#!/bin/bash

# Description:
# This script performs indel realignment on BAM files using GATK's IndelRealigner.
# Indel realignment corrects misalignments around insertions and deletions (indels) in the
# reference genome. This step is crucial for improving the accuracy of variant calling by
# aligning reads around indels more precisely, thereby reducing artifacts and improving
# the reliability of downstream analyses.

# Tool:
# GATK's IndelRealigner is used to realign reads around indels to correct misalignments
# that may have occurred during sequencing. The tool uses the intervals created by 
# RealignerTargetCreator to focus the realignment process on specific regions, thus enhancing
# the accuracy of the alignment.

# Variables
ref=  # Path to the reference genome fasta file (e.g., "/path/to/reference/reference.fna")
bam=  # Directory containing the BAM files with duplicates marked and realignment targets (e.g., "/path/to/dedup_bam")
files="sample1 sample2 sample3 sample4 sample5 sample6"  # List of sample names (without file extensions)

# Perform Indel Realignment
# The following loop iterates through each sample and runs GATK's IndelRealigner
# to realign reads around indels. The command specifies the reference genome, 
# input BAM file, target intervals for realignment, and the output file for realigned BAM.

for sample in $files; do
  gatk -Xmx20G -T IndelRealigner \
  -R $ref/reference.fna \
  -I $bam/${sample}_dedup.bam \
  -targetIntervals $bam/${sample}.realn.intervals \
  -o $bam/${sample}.realign.bam \
  -allowPotentiallyMisencodedQuals \
  -S LENIENT
  
  echo "Indel realignment completed for $sample"
done

echo "Indel realignment completed for all samples"
