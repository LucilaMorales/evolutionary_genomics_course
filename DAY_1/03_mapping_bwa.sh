#!/bin/bash

# Description:
# This script maps trimmed sequencing reads to a reference genome using BWA-MEM2, 
# a fast and accurate aligner for high-throughput sequencing reads. 
# Mapping is a critical step in the analysis pipeline, allowing the alignment of sequencing reads 
# to the reference genome, which is essential for downstream tasks like variant calling, 
# assembly, and other genomic analyses.

# Tool:
# BWA-MEM2 is an enhanced version of BWA-MEM, optimized for performance and speed, 
# especially when dealing with large genomes. It aligns reads to the reference genome, 
# generating a Sequence Alignment/Map (SAM) file, which can be further processed with tools like samtools.
# The mapping process incorporates information about the sequencing run, including the read group, 
# which is important for identifying the origin of the reads in downstream analyses.

# Variables
trm=  # Path to the trimmed FASTQ files (e.g., "/path/to/trimmed/sample_R1.fq.gz /path/to/trimmed/sample_R1.fq.gz")
bam=  # Output path for the resulting BAM file (e.g., "/path/to/output/sample.bam")
ref=  # Path to the reference genome index (e.g., "/path/to/reference_genome")

# Mapping with BWA-MEM2
# The command below uses BWA-MEM2 to align the trimmed reads to the reference genome.
# - The `-t` option specifies the number of threads to use.
# - The `-M` flag marks shorter split hits as secondary (useful for Picard compatibility).
# - The `-R` option adds read group information, which includes details like the sample ID (SM), platform (PL), 
#   and other metadata necessary for downstream processing.
# - The output is piped directly into samtools to convert the SAM file to a BAM file, 
#   apply quality filtering, and ensure that only properly paired reads are included.

bwa-mem2 mem -t 4 -M -R '@RG\tID:sampleID\tLB:libraryID\tPL:ILLUMINA\tPU:unitID\tSM:sampleName' \
$ref/reference_index $trm/sample1_R1.fq.gz $trm/sample1_R2.fq.gz | \
samtools view -bh -@ -q 30 -f 0x2 > $bam/sample1.bam

echo "Mapping completed and BAM file generated: $bam"
