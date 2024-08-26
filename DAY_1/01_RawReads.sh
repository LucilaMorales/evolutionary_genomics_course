#!/bin/bash

# Description:
# This script performs a quality check on raw sequencing reads stored in FASTQ format. 
# Assessing the quality of the raw reads is a critical first step in data preprocessing, 
# ensuring that the data is suitable for downstream analyses. Low-quality reads, 
# sequencing artifacts, and other issues can be identified early on, allowing for informed 
# decisions about further data processing.

# Tool:
# We use 'FastQC' for this quality check. FastQC is a widely-used tool for providing an 
# overview of basic quality metrics for high-throughput sequencing data. It generates 
# detailed reports on the quality of the reads, which helps in identifying any issues 
# that might require further trimming or filtering.

# Variables
FILE=  # Specify the filename or pattern to process (e.g., "*.fastq.gz" to process all FASTQ files)
DIRECTORY=  # Specify the directory where the FASTQ files are located

# Quality Check with FastQC
# The command below runs FastQC on each specified FASTQ file in the directory. 
# FastQC can handle both uncompressed and compressed (e.g., .gz) FASTQ files.
# The output reports will be saved in the same directory as the input files or 
# in a specified output directory if desired.

ls $DIRECTORY/$FILE | xargs -I{} -P 4 fastqc -o $DIRECTORY -f fastq {}

echo "Quality check completed for all specified FASTQ files"

