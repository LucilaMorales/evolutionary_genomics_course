#!/bin/bash

# Directorios base
practico="/Users/dalynoll/Dropbox/PRESENTACIONES_CHARLAS_Y_SEMINARIOS/2024_curso_Genomica-Valdivia/Practico_dia3/practico"
normalized="$practico/cds/1_agat_normalized"
common_genes="$practico/cds/common_genes"
grouped="$practico/cds/grouped"

# Crear directorio para los archivos agrupados si no existe
mkdir -p $grouped

# Leer la lista de genes comunes
while IFS= read -r gene; do
    output_file="$grouped/${gene}.fa"
    # Inicializar archivo de salida
    > "$output_file"
    # Extraer y concatenar las secuencias de cada gen común en un archivo por gen
    for fa_file in $normalized/*.fa; do
        sample_name=$(basename "$fa_file" ".fa")
        # Remover el sufijo "_cds" del nombre de la muestra
        sample_name="${sample_name%_cds}"
        # Añadir el nombre de la muestra al header de cada secuencia
        awk -v gene=">$gene" -v name="$sample_name" '$0 == gene {print ">" name; flag=1; next} /^>/ {flag=0} flag {print}' $fa_file >> "$output_file"
    done
done < "$common_genes/genes_comunes.txt"

echo "Archivos de genes comunes generados en $grouped."
