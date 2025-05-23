# M.senegalensis-core-microbiota

In this work we aimed to investigate the differences in the microbiome community structure related of *Maytenus senegalensis* in two different natives environment: Spain (arid zone) and Senegal (humid zone). By comparing those conditions we can similate the effect of climate change on the soil microbiote.  

Moreover, despite the differences of the microbiote community structure, some taxa can be associated to Maytenus shrub. Therefore, we aimed to investigate the potential core microbiote of *Maytenus senegalensis* shrub.

To this end, we have collected different soil samples:  
-**Understory**: soil was sampled in the first 10 cm under Maytenus shrub.  
-**Gap**: soil was sampled in a close area but without the direct influence of Maytenus shrub.  


This repository stores the code available to perform an amplicon analysis with QIIME2 and downstream analysis with R.  
This code can be run in any Linux system. However, if you are a Windows user you need to run QIIME2 part in WSL.  

## Clone the repository  

Clone the repository M.senegalensis-core-microbiote and make the path accesible for functions file in all the reports at ITS and 16S directories:  

```{r }
source("../M.senegalensis-core-microbiota/functions.R")
``` 
  
## Download QIIME2  
This analysis was performed with QIIME2 2023.5 version. To install QIIME2 follow the [instructions](https://docs.qiime2.org/2023.5/install/index.html).  
In case you want to use updated version of QIIME2 install amplicon version.  
  
## Download pretrained classifiers  
We used SILVA and UNITE pretrained classifiers that are available at [QIIME2 web](https://docs.qiime2.org/2023.5/data-resources/). Create a taxonomy_classifier directory and save the .qza files inside. 
  
```{bash }
mkdir taxonomy_classifier

curl https://data.qiime2.org/2023.5/common/silva-138-99-nb-classifier.qza -o taxonomy_classifier/silva-138-99-nb-classifier.qza
curl https://github.com/colinbrislawn/unite-train/releases/download/v9.0-v25.07.2023-qiime2-2023.5/unite_ver9_dynamic_all_25.07.2023-Q2-2023.5.qza -o taxonomy_classifier/unite_ver9_dynamic_all_25.07.2023-Q2-2023.5.qza
```
  
Make sure that the name of the classifiers correspond to the paths in:
  
```{bash }
16S/qiime2_pipeline_16S/3_assing_taxonomy.sh   #line 16

ITS/qiime2_pipeline_ITS/3_assing_taxonomy.sh   #line 17
```

## Download R and RStudio  
R analysis can be run in any computer.  
Donwload [R](https://cran.r-project.org/bin/windows/base/), and also you can download [RStudio](https://posit.co/download/rstudio-desktop/) in case you do not want to use command-line.  
  
### Install R packages  
Before to start the analysis you need to install the following CRAN packages:  

```{r }
install.packages(c("ggplot2", "ggpubr", "ggVennDiagram", rmarkdown", "kableExtra", "pander" "dplyr", "magrittr", "vegan", "VennDiagram", "multcompView", "forcats"))
``` 
  
Furthermore, these bioconductor packages should be installed using the the BiocManager package:  

```{r }
BiocManager::install(c("phyloseq", "microbiomeMarker", "microbiome", "DESeq2"))
```
  
Also, you may download other packages from github:  
  
```{r }
install.packages('devtools')
library(devtools)
install_github("pmartinezarbizu/pairwiseAdonis/pairwiseAdonis")
install_github("jbisanz/qiime2R")
```

## Execution Details   

Save your raw sequences in a directory named raw data. Scripts for 16S and ITS analyses are available in the directory with its corresponding name.  

**1.** First you need to execute QIIME2. The scripts are available in qiime2_pipeline_16S/ITS directory. You need to execute the scripts in order:  
- *1_import_qiime2_sequence.sh*:  import the sequences in QIIME2 and execute cutadapt pluggin.  
- *2_dada2.sh*: execute DADA2 plugin.  
- *3_assing_taxonomy.sh*: assing the taxonomy.  
- *4_phylogeny.sh*: generate a rooted and unrooted phylogenetic trees.  
  
**2.** Run Rmkardown templates.  
With QIIME2 output we can perform different analysis. The Rmarkdown templates (*Report_16S/ITS.rmd*) contains the code for downstream analysis and generates a report in HTML.  

There are to ways to obtain the reports:   
- RStudio:
Open RStudio, set the working directory and execute the following commands:  
  
```{r}
library(rmarkdown)

#for 16S analysis
setwd(PATH/TO/16S)
render("Report_16S.Rmd")

#for ITS analysis
setwd(PATH/TO/ITS)
render("Report_ITS.Rmd")
```

- Command line:  
To compile the HTML report in a command line use the followin command:

```{bash }
#for 16S analysis
Rscript -e "rmarkdown::render("Report_16S.Rmd")"

#for ITS analysis
Rscript -e "rmarkdown::render("Report_ITS.Rmd")"
```

Do not forget to set the path for the functions.R file before to compile the reports. Moreover, you need to excute the reports in 16S or ITS directory in order to have QIIME2 outputs accesible for the reports. In case you customize QIIME2 output modify the path to the files needed in the report templates.  
  
## Citation

If you use some of the code available in this repository please cite this article:
