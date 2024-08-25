#!/bin/bash

# Description:
# This script prepares VCF files for RAiSD analysis. It includes generating VCF files in the correct format,
# splitting VCF files by population or species, separating them by chromosome/scaffold, and running RAiSD.
# Each step is crucial to ensure that the input files for RAiSD are correctly formatted and ready for selection
# sweep analysis.

# Step 1: Generate VCF in the Correct Format (GT)
# This step ensures that the VCF file is annotated with genotype (GT) information only, removing any other FORMAT fields.
# The output is a VCF file compressed in gzip format.

VCF=path/to/input.vcf.gz  # Replace with your input VCF file
bcftools annotate -x '^FORMAT/GT' $VCF -Oz -o GT.vcf.gz

# Step 2: Generate VCF for Each Genetic Population/Species
# This step creates VCF files for each specified population or species by keeping only the individuals listed in `pop1.txt`.
# It outputs the VCF file compressed in gzip format.

VCF=path/to/GT.vcf.gz  # Replace with your input GT VCF file
vcftools --gzvcf $VCF --recode --stdout --keep pop1.txt | bcftools view -c 1 | gzip -c > pop1_GT.vcf.gz

# Step 3: Generate VCF by Chromosome/Scaffold
# This step splits the VCF file by chromosome or scaffold as specified in `scaffolds/chr_list.txt`.
# Each chromosome/scaffold is processed and outputted as a separate VCF file.

VCF=path/to/pop1_GT.vcf.gz  # Replace with your input pop1_GT VCF file
lista=$(cat "scaffolds/chr_list.txt")  # List of chromosomes or scaffolds
for i in $lista; do
    vcftools --gzvcf pop1_GT.vcf.gz --chr $i --recode --recode-INFO-all --out ${i} &
done
wait  

# Step 4: Run RAiSD
# This step runs RAiSD for each chromosome or scaffold VCF file generated in the previous step.
# Ensure the path to RAiSD and options are set correctly.

vcf=path/to/vcf_files  # Replace with the directory containing VCF files
list=$(cat "scaffolds/chr_list.txt")  # List of chromosomes or scaffolds
for i in $list; do
    /path/to/RAiSD -n $i -I $vcf/${i}.recode.vcf -D -O -s -t -R -f
done
wait 

echo "RAiSD analysis completed successfully"
