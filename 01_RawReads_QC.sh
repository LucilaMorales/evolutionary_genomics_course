# Preprocessing Data

# FASTQ Format 
# The raw sequencing reads are stored in FASTQ format. To evaluate the quality of these reads, we use the FastQC tool.
# FastQC can be executed with a single FASTQ file or a list of files as input. It also supports compressed files.

# Variables
FILE= # Specify the filename or pattern to process (e.g., "*.fastq.gz" for all FASTQ files)
DIRECTORY= # Specify the directory where the FASTQ files are located

# Quality Check with FastQC
# The following command will run FastQC on each specified file in the directory.
# The results will be saved in the same directory as the input files.

ls $DIRECTORY/$FILE | xargs -I{} -P 4 fastqc -o $DIRECTORY -f fastq {}
