OHDSI COVID-19 Studyathon: Alpha-1 blocker for Palliating Inflammatory injury Severity (APIS) study
==============================

<img src="https://img.shields.io/badge/Study%20Status-Design%20Finalized-brightgreen.svg" alt="Study Status: Design Finalized">

- Analytics use case(s): **Population-Level Estimation**
- Study type: **Clinical Application**
- Tags: **Study-a-thon, COVID-19**
- Study lead: **Aki Nishimura, Daniel Prieto Alhambra, Marc A. Suchard**
- Study lead forums tag: **[aki-nishimura](https://forums.ohdsi.org/u/aki-nishimura), [Daniel_Prieto](https://forums.ohdsi.org/u/daniel_prieto), [msuchard](https://forums.ohdsi.org/u/msuchard)**
- Study start date: **July 7th, 2020**
- Study end date: **-**
- Protocol: **[PDF](https://github.com/ohdsi-studies/TBD/)**
- Publications: **-**
- Results explorer: **-**

This study will evaluate the association between prevalent use of alpha-1 blockers (ɑ-1B) and the risk of contracting COVID-19 infection and of subsequently requiring hospitalization and intensive services such as mechanical ventilation.
The analysis will be undertaken across a federated multi-national network of electronic health records and administrative claims from primary care and secondary care that have been mapped to the Observational Medical Outcomes Partnership Common Data Model in collaboration with the Observational Health Data Sciences and Informatics (OHDSI) and European Health Data and Evidence Network (EHDEN) initiatives.
These data reflect the clinical experience of patients from six European countries (Belgium, Netherlands, Germany, France, Spain, and Estonia) the United Kingdom, the United States of America, South Korea, and Japan as data becomes available.
We will use a prevalent user cohort design to estimate the relative risk of each outcome using an on-treatment analysis of monotherapy.
Data driven approaches will be used to identify potential covariates for inclusion in matched or stratified propensity score models identified using regularized logistic regression.
Large-scale propensity score matching and stratification strategies that allow balancing on a large number of baseline potential confounders will be used in addition to negative control outcomes to allow for evaluating residual bias in the study design as a whole as a diagnostic step.

This study is part of the [OHDSI 2020 COVID-19 study-a-thon](https://www.ohdsi.org/covid-19-updates/).

Requirements
============

- A database in [Common Data Model version 5](https://github.com/OHDSI/CommonDataModel) in one of these platforms: SQL Server, Oracle, PostgreSQL, IBM Netezza, Apache Impala, Amazon RedShift, or Microsoft APS.
- R version 3.5.0 or newer
- On Windows: [RTools](http://cran.r-project.org/bin/windows/Rtools/)
- [Java](http://java.com)
- 25 GB of free disk space

See [this video](https://youtu.be/K9_0s2Rchbo) for instructions on how to set up the R environment on Windows.

How to run
==========
1. You will build a library `Covid19IncidenceAlphaBlockers` from the folder of the same name, which also contain installation instruction.

 *Note: If you encounter errors in devtools pulling the study packages, you may find it easier to download the repo zip locally and uploading it through your RStudio console. Instructions to upload packages are provided in [The Book of OHDSI](https://ohdsi.github.io/TheBookOfOhdsi/PopulationLevelEstimation.html#running-the-study-package).*

2. When completed, the output will exist as a .ZIP file in the `export` directory in the `output` folder location. This file contains the results to submit to the study lead. To do so, please use the function below.  You must supply the directory location to where you have saved the `<study key name>.dat` file to the `privateKeyFileName` argument. You must contact the [study coordinator](mailto:kristin.kostka@iqvia.com) to receive the required private key.

  ```r
	keyFileName <- "<directory location of where you saved the study key name.dat>"
	userName <- "study-data-site-covid19"
	OhdsiSharing::sftpUploadFile(privateKeyFileName = keyFileName,
                             userName = userName,
                             remoteFolder = "Covid19Apis",
                             fileName = "<directory location of outputFolder/export>")
  ```

  If you are unable to utilize the `OhdsiSharing` package, you may utilize a SFTP client of your choosing (e.g. FileZilla) and upload through that tool. If you have questions, contact the [study coordinator](mailto:kristin.kostka@iqvia.com).

Suggested PostgreSQL cache settings
==========
```
max_connections = 40
shared_buffers = 64GB
effective_cache_size = 192GB
maintenance_work_mem = 2GB
checkpoint_completion_target = 0.9
wal_buffers = 16MB
default_statistics_target = 500
random_page_cost = 4
effective_io_concurrency = 2
work_mem = 209715kB
min_wal_size = 4GB
max_wal_size = 16GB
max_worker_processes = 8
max_parallel_workers_per_gather = 4
max_parallel_workers = 8
```

License
=======
The `Covid19IncidenceAlphaBlockers` is licensed under Apache License 2.0
