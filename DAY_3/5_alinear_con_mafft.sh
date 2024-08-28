#!/bin/bash

# Directorios base
practico="/Users/dalynoll/Dropbox/PRESENTACIONES_CHARLAS_Y_SEMINARIOS/2024_curso_Genomica-Valdivia/Practico_dia3/practico"
grouped="$practico/cds/grouped"
aligned="$practico/cds/aligned"

# Crear directorio para los alineamientos si no existe
mkdir -p $aligned

# Alinear cada archivo de secuencias con MAFFT
for fa_file in $grouped/*.fa; do
    output_file="$aligned/$(basename "$fa_file" ".fa")_aligned.fa"
    # Ejecutar MAFFT en cada archivo y guardar el resultado
    mafft --auto "$fa_file" > "$output_file"
done

echo "Alineamientos completados y guardados en $aligned."

