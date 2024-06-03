## Background

This repositorty contains code for performing bioinformatic analysis of *P. falciparum* next-generation sequencing (NGS) data. The repo contains multiple analysis pipelines. The GeoPrediction and MaRS analyses can be run with amplicon or selective whole genome sequencing (sWGA) data, while the sWGA VCF pipeline should only be run with sWGA data. 

All code in this repository is designed to run on CDC SciComp environment from the CycloDeploy Group Working Area

### Remove Human Reads

Human derived reads must be removed from the sWGA before any analysis is run. Likewise, sWGA data uploaded to NCBI SRA must have human-dreived reads removed.

To run human read removal

### Geo Prediction

#### Prediction with pfs47 and cpmp

#### Prediction with 221 SNP barcode (TBD)

### Malaria Resistance Surveillance (MaRS)

### Pfal_sWGA_VCF

This repository contains a variant calling workflow (VCF) for selective whole genome amplification (sWGA) data generated for *Plasmodium falciparum*. The pipeline is a nextflow conversion of the the bash pipeline from [Niare et al. 2023][https://link.springer.com/article/10.1186/s12936-023-04632-0] (see their [GitHub page][https://github.com/Karaniare/Optimized_GATK4_pipeline/tree/main]). 

Our code also uses a container created by Niare et al.; however, some adaptations were required to run on CDC's SciComp in nextflow. Therefore, you must run the code in CDC's SciComp environment and this code is not meant to be deployed into other environments. 

### SNIPPY

#### TBD

### Clustering

#### TBD

### Report Generation

#### TBD



