#!/bin/bash
conda activate iqtree

iqtree -s $concat/gentooConcat.fasta -m TEST -bb 1000

### corre en el directorio donde está el input concatenado
