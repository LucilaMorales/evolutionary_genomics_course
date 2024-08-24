#!/bin/bash

# Description:
# This script trims raw sequencing reads to remove low-quality bases, adapter sequences,
# and other unwanted sequences from the data. Trimming is a crucial preprocessing step
# that improves the overall quality of the reads, leading to more accurate downstream
# analyses such as mapping, variant calling, and assembly. By removing poor-quality
# sequences, we reduce noise in the data, minimize biases, and increase the reliability
# of the results.

# Tool:
# We use 'fastp' for this trimming process. 'fastp' is a fast all-in-one preprocessing 
# tool designed to provide quality control, adapter trimming, quality filtering, and 
# many other preprocessing tasks. It is particularly effective for processing high-throughput
# sequencing data.

# Define directories
genomas="/path/to/genomes"  # Specify the path to the directory containing raw reads
trimmed="/path/to/trimmed"  # Specify the path to the directory where trimmed reads will be saved

# List of samples to process
files= # List your sample names here

# Loop through each sample and run fastp for trimming
for sample in $files; do
  fastp \
  -i $genomas/${sample}_R1.fastq.gz \
  -I $genomas/${sample}_R2.fastq.gz \
  -o $trimmed/${sample}_1.fq.gz \
  -O $trimmed/${sample}_2.fq.gz \
  --adapter_fasta /path/to/all_adapters.fa \  # Specify the path to your adapter file
  --thread \  # Specify the number of threads to use
  --json ${trimmed}/${sample}_fastp.json \  # Save JSON output with sample-specific names
  --html ${trimmed}/${sample}_fastp.html    # Save HTML report with sample-specific names
  
  echo "Trimming completed for $sample"
done

echo "All samples processed successfully."
