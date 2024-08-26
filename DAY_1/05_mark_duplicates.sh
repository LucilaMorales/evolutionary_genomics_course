#!/bin/bash

# Description:
# This script marks duplicate reads in sorted BAM files using Picard's MarkDuplicates tool.
# Duplicate reads can arise during sequencing or PCR amplification and may lead to biased 
# variant calling if not removed. Marking duplicates helps to reduce such biases by 
# identifying and tagging duplicate reads without removing them from the dataset, allowing 
# for accurate downstream analyses such as variant calling and structural variant detection.

# Tool:
# Picard's MarkDuplicates is a tool that identifies and marks duplicate reads in BAM files. 
# Duplicate reads are those that have the same start position and are often the result 
# of PCR amplification. MarkDuplicates provides options to either remove duplicates 
# or just mark them, and it also generates metrics that are useful for assessing the 
# duplication level in the dataset.

# Variables
bam=  # Directory containing the sorted BAM files (e.g., "/path/to/sorted_bam")
files="sample1 sample2 sample3 sample4 sample5 sample6"  # List of sample names (without file extensions)

# Mark Duplicates
# The following loop iterates through each sample and runs Picard's MarkDuplicates on the 
# corresponding sorted BAM file. The output is a BAM file with duplicates marked, and 
# additional metrics are saved to a text file. The script also creates an index for the 
# deduplicated BAM file and uses a specified temporary directory for intermediate files.

for sample in $files; do
  picard MarkDuplicates -Xmx20G \
  --INPUT $bam/${sample}_sorted.bam \
  --OUTPUT $bam/${sample}_dedup.bam \
  --METRICS_FILE $bam/${sample}_dedup_metrics.txt \
  --REMOVE_DUPLICATES false \
  --CREATE_INDEX true \
  --TMP_DIR /path/to/tmp_dir  # Specify a directory for temporary files
  
  echo "Duplicate marking completed for $sample"
done

echo "All samples processed for duplicate marking successfully"
