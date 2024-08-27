#!/bin/bash

# Description:
# This script maps trimmed sequencing reads to a reference genome using BWA-MEM2, 
# a fast and accurate aligner optimized for high-throughput sequencing data. 
# Mapping aligns sequencing reads to the reference genome, generating a BAM file 
# essential for downstream analyses such as variant calling, assembly, and other genomic studies.

# Tool:
# BWA-MEM2 is an advanced version of BWA-MEM designed for improved performance and speed, 
# especially for large genomes. It generates a Sequence Alignment/Map (SAM) file, which 
# is then converted to a BAM file using samtools. The mapping includes read group information 
# for better downstream processing.

# Variables
trm=  # Path to the directory containing trimmed FASTQ files (e.g., "/path/to/trimmed/")
bam=  # Path to the output directory for BAM files (e.g., "/path/to/output/")
ref=  # Path to the reference genome (e.g., "/path/to/reference_genome.fa")

# Mapping with BWA-MEM2
# The following command aligns the trimmed reads to the reference genome:
# - `-t` specifies the number of threads to use.
# - `-M` marks shorter split hits as secondary, which is useful for compatibility with Picard tools.
# - `-R` specifies read group information, which includes sample ID (SM), library ID (LB), platform (PL), 
#   and other metadata. Replace placeholders with actual values.
# - The output SAM file is piped to `samtools view` to convert it to a BAM file, apply quality filtering, 
#   and ensure that only properly paired reads are included.

bwa-mem2 mem -t 4 -M -R '@RG\tID:sampleID\tLB:libraryID\tPL:ILLUMINA\tPU:unitID\tSM:sampleName' \
$ref $trm/sample1_R1.fq.gz $trm/sample1_R2.fq.gz | \
samtools view -bh -@ 4 -q 30 -f 0x2 > $bam/sample1.bam

echo "Mapping completed and BAM file generated: $bam/sample1.bam"

# Preparing Reference Genome:
# Before mapping, ensure that the reference genome is properly indexed:
# - Index the reference genome using BWA-MEM2.
# - Create a sequence dictionary for the reference using Picard.
# - Generate a FASTA index file using samtools.

bwa-mem2 index $ref $ref.index
picard CreateSequenceDictionary -R $ref -O $ref.dict
samtools faidx $ref

echo "Reference genome preparation completed: $ref.index, $ref.dict, $ref.fai"
