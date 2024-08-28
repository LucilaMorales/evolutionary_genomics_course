#!/bin/bash

mkdir cds/1_agat

anotacion=/ruta/directorio/anotacion
genomas=/ruta/directorio/genomas
cds=/ruta/directorio/cds

file="G4
G5
G6
G7
chins"

for i in $file
do
agat_sp_extract_sequences.pl -g $anotacion/GCA_010090195.1_BGI_Ppap.V1_genomic_filtrado.gff3 -f $genomas/${i}_maskedPygo_filtrado.fa -o $cds/1_agat/${i}_cds.fa
done
