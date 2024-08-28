#!/bin/bash

# Directorios base
practico=/Users/dalynoll/Dropbox/PRESENTACIONES_CHARLAS_Y_SEMINARIOS/2024_curso_Genomica-Valdivia/Practico_dia3/practico
agat="$practico/cds/1_agat"
normalized="$practico/cds/1_agat_normalized"

# Crear directorio para los archivos normalizados si no existe
mkdir -p $normalized

# Normalizar los headers de cada archivo FASTA
for fa_file in $agat/*.fa; do
    base_name=$(basename "$fa_file")
    awk '/^>/ {
        # Usar split para extraer el ID del gen
        n = split($0, array, " ")
        for (i in array) {
            if (array[i] ~ /^gene=gene-/) {
                gsub("gene=gene-", "", array[i])
                print ">" array[i]
                next
            }
        }
    }
    !/^>/ {print}' "$fa_file" > "$normalized/$base_name"
done

echo "Headers normalizados guardados en $normalized."



