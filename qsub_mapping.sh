#!/bin/bash -l
#$ -e mapping.err
#$ -o mapping.out
#$ -N mapping
#$ -q cyclospora.q
#$ -cwd
#$ -pe smp 14

myDir=/scicomp/groups-pure/Projects/CycloDeploy/Plasmodium_Ampliseq_Nextflow/P_vivax_GeoPrediction

export LC_ALL=C
#export JAVA_CMD=/usr/bin/java
# export JAVA_CMD=/apps/x86_64/java/openjdk1.8.0_41/bin/java

#module load miniconda3
module load nextflow

myDate=$(date +"%Y-%m-%d_%H-%M-%S")

#Modify below this line

# nextflow run main.nf -entry mapHuman_then3D7 -profile singularity -with-report nextflow_logFiles/$myDate\_report.html -with-trace nextflow_logFiles/$myDate\_trace.txt

# nextflow run main.nf -entry just3D7 -profile singularity -with-report nextflow_logFiles/$myDate\_report.html -with-trace nextflow_logFiles/$myDate\_trace.txt

# nextflow run main.nf -entry myDepth -profile singularity -with-report nextflow_logFiles/$myDate\_report.html -with-trace nextflow_logFiles/$myDate\_trace.txt -resume

nextflow run main.nf -entry optimizedGATK4_VCF -profile singularity -with-report nextflow_logFiles/$myDate\_report.html -with-trace nextflow_logFiles/$myDate\_trace.txt -resume


