library(Covid19SusceptibilityAlphaBlockers)

pkg_folder <- path.expand("~/Dropbox/Documents_Academic/Covid19AlphaBlocker")
zipFiles <- list(
  SIDIAP='200918_Results_SIDIAP.zip',
  `VA-OMOP`='200929_Results_VA_OMOP.zip',
  IQVIA_OpenClaims="200725_Results_IQVIA_OpenClaims.zip",
  CUIMC="200906_Results_CUIMC.zip",
  Optum_DOD='201010_Results_Optum_DOD.zip',
  Optum_EHR_COVID='201010_Results_Optum_EHR_COVID.zip'
)

for (databaseId in names(zipFiles)) {
  outputFolder <- file.path(pkg_folder, databaseId)
  resultsZipFile <- file.path(pkg_folder, "export", zipFiles[[databaseId]])
  dataFolder <- file.path(pkg_folder, databaseId, "shinyData")
  prepareForEvidenceExplorer(resultsZipFile = resultsZipFile, dataFolder = dataFolder, prettyLabels = TRUE)
}

## Negative control calibration
analysisIds <- c(5, 6) # Analysis 5 & 6 -- Large-scale PS stratification & matching
for (databaseId in names(zipFiles)) {
  doNegativeControlCalibration(studyFolder = file.path(pkg_folder, databaseId),
                               databaseIds = databaseId,
                               analysisIds = analysisIds)
}

## Meta analysis
studyFolder <- pkg_folder
outputFolders <- c(file.path(studyFolder, "SIDIAP"),
                   file.path(studyFolder, "VA-OMOP"),
                   # file.path(studyFolder, "CUIMC"), # Exclude Columbia from meta-analysis
                   file.path(studyFolder, "IQVIA_OpenClaims"),
                   file.path(studyFolder, "Optum_DOD"),
                   file.path(studyFolder, "Optum_EHR_COVID"))

doMetaAnalysis(studyFolder = studyFolder,
               outputFolders = outputFolders,
               maOutputFolder = file.path(studyFolder, "Meta-analysis"),
               maxCores = 4)

doNegativeControlCalibration(studyFolder = file.path(studyFolder, "Meta-analysis"),
                             databaseIds = "Meta-analysis",
                             analysisIds = c(5, 6))

## Copy file to the EvidenceExplorer folder
fullShinyDataFolder <- paste(pkg_folder, "inst/shiny/EvidenceExplorer/data", sep = '/')
for (databaseId in names(zipFiles)) {
  file.copy(from = list.files(file.path(studyFolder, databaseId, "shinyData"), full.names = TRUE),
            to = fullShinyDataFolder,
            overwrite = TRUE)
}
launchEvidenceExplorer(dataFolder = fullShinyDataFolder, blind = FALSE, launch.browser = FALSE)
