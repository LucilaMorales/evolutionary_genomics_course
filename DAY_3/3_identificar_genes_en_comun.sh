#!/bin/bash

# Directorios base
practico="/Users/dalynoll/Dropbox/PRESENTACIONES_CHARLAS_Y_SEMINARIOS/2024_curso_Genomica-Valdivia/Practico_dia3/practico"
normalized="$practico/cds/1_agat_normalized"
common_genes="$practico/cds/common_genes"

# Crear directorio para los genes comunes si no existe
mkdir -p $common_genes

# Archivo para almacenar genes de cada muestra
temp_files=()

# Contar la ocurrencia de cada gen en todos los archivos
for fa_file in $normalized/*.fa; do
    temp_file=$(mktemp)
    temp_files+=("$temp_file")
    awk '/^>/ {gsub(">", "", $0); print $0}' $fa_file | sort | uniq > "$temp_file"
done

# Utilizar 'comm' para encontrar genes comunes entre todas las muestras
comm_file="${temp_files[0]}"
for (( i=1; i<${#temp_files[@]}; i++ )); do
    comm -12 "$comm_file" "${temp_files[$i]}" > "${temp_files[$i]}.tmp"
    mv "${temp_files[$i]}.tmp" "$comm_file"
done

# Mover el archivo final de genes comunes al destino
mv "$comm_file" "$common_genes/genes_comunes.txt"

# Limpiar archivos temporales excepto el archivo final de genes comunes
for temp_file in "${temp_files[@]}"; do
    if [[ "$temp_file" != "$comm_file" ]]; then
        rm "$temp_file"
    fi
done

echo "Lista de genes comunes generada en $common_genes/genes_comunes.txt."
