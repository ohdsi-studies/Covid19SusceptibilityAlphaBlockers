# Create analysis plans

# Manually select essential covariates.
makeCovariateIdsToInclude <- function(includeIndexYear = FALSE) {
  ageGroupIds <- unique(
    floor(c(18:110) / 5) * 1000 + 3
  )
  
  # Index month
  monthIds <-c(1:12) * 1000 + 7
  
  # Gender
  genderIds <- c(8507, 8532) * 1000 + 1
  
  # Index year
  if (includeIndexYear) {
    yearIds <- c(2016:2019) * 1000 + 6
  } else {
    yearIds <- c()
  }
  
  return(c(ageGroupIds,monthIds,yearIds,genderIds))
}

# alpha-blockers: http://atlas-covid19.ohdsi.org/#/conceptset/406/conceptset-expression
alphaBlockerConceptIds <- c(
  1341238,
  924566,
  19012925,
  1350489,
  1363053,
  930021
)
# 5-alpha reductase inhibitors: http://atlas-covid19.ohdsi.org/#/conceptset/407/conceptset-expression
fiveAlphaRiConceptIds <- c(
  996416,
  989482
)
bphIngredientConceptIds <- c(alphaBlockerConceptIds, fiveAlphaRiConceptIds)

firstExposureOnly <- FALSE # TODO Reconfirm
studyStartDate <- ""
fixedPsVariance <- 1 # TODO confirm
fixedOutcomeVariance <- 4

covarSettingsWithBphMeds <- FeatureExtraction::createDefaultCovariateSettings()
covarSettingsWithBphMeds$mediumTermStartDays <- -90
covarSettingsWithBphMeds$longTermStartDays <- -180

covarSettingsWithoutBphMeds <- FeatureExtraction::createDefaultCovariateSettings(
  excludedCovariateConceptIds = bphIngredientConceptIds,
  addDescendantsToExclude = TRUE
)
covarSettingsWithoutBphMeds$mediumTermStartDays <- -90
covarSettingsWithoutBphMeds$longTermStartDays <- -180

getDbCmDataArgsWithBphMeds <- CohortMethod::createGetDbCohortMethodDataArgs(
  firstExposureOnly = firstExposureOnly,
  studyStartDate = studyStartDate,
  removeDuplicateSubjects = "remove all",
  excludeDrugsFromCovariates = FALSE,
  covariateSettings = covarSettingsWithBphMeds
)

getDbCmDataArgsWithoutBphMeds <- CohortMethod::createGetDbCohortMethodDataArgs(
  firstExposureOnly = firstExposureOnly,
  studyStartDate = studyStartDate,
  removeDuplicateSubjects = "remove all",
  excludeDrugsFromCovariates = FALSE,
  covariateSettings = covarSettingsWithoutBphMeds
)

createStudyPopArgs <- CohortMethod::createCreateStudyPopulationArgs(
  removeSubjectsWithPriorOutcome = TRUE,
  minDaysAtRisk = 0
)

createMinPsArgs <- CohortMethod::createCreatePsArgs(
  stopOnError = FALSE,
  maxCohortSizeForFitting = 100000,
  includeCovariateIds = makeCovariateIdsToInclude(),
  prior = Cyclops::createPrior(priorType = "normal",
                               variance = fixedPsVariance,
                               useCrossValidation = FALSE))

createLargeScalePsArgs <- CohortMethod::createCreatePsArgs(
  stopOnError = FALSE,
  maxCohortSizeForFitting = 100000,
  prior = Cyclops::createPrior(priorType = "laplace",
                               useCrossValidation = TRUE))

fitUnadjustedOutcomeModelArgs <- CohortMethod::createFitOutcomeModelArgs(
  modelType = "cox",
  useCovariates = FALSE,
  stratified = FALSE)

fitAdjustedOutcomeModelArgs <- CohortMethod::createFitOutcomeModelArgs(
  modelType = "cox",
  useCovariates = TRUE,
  includeCovariateIds = makeCovariateIdsToInclude(),
  stratified = FALSE,
  prior = Cyclops::createPrior(priorType = "normal",
                               variance = fixedOutcomeVariance,
                               useCrossValidation = FALSE))

fitPsOutcomeModelArgs <- CohortMethod::createFitOutcomeModelArgs(
  modelType = "cox",
  useCovariates = FALSE,
  stratified = TRUE)

fitPsOutcomeModelArgs$control$profileLogLikelihood <- TRUE

stratifyByPsArgs <- CohortMethod::createStratifyByPsArgs(numberOfStrata = 5)

matchByPsArgs <- CohortMethod::createMatchOnPsArgs(
  maxRatio = 10
)
matchByPsArgs$allowReverseMatch <- TRUE

# Analysis 1 -- crude/unadjusted

cmAnalysis1 <- CohortMethod::createCmAnalysis(analysisId = 1,
                                              description = "Crude/unadjusted",
                                              getDbCohortMethodDataArgs = getDbCmDataArgsWithoutBphMeds,
                                              createStudyPopArgs = createStudyPopArgs,
                                              createPs = FALSE,
                                              fitOutcomeModel = TRUE,
                                              fitOutcomeModelArgs = fitUnadjustedOutcomeModelArgs)

# Analysis 2 -- adjusted outcome: direct covariate adjustment without propoensity score

cmAnalysis2 <- CohortMethod::createCmAnalysis(analysisId = 2,
                                              description = "Adjusted outcome",
                                              getDbCohortMethodDataArgs = getDbCmDataArgsWithoutBphMeds,
                                              createStudyPopArgs = createStudyPopArgs,
                                              createPs = FALSE,
                                              fitOutcomeModel = TRUE,
                                              fitOutcomeModelArgs = fitAdjustedOutcomeModelArgs)

# Analysis 3 -- minimal PS stratification
# 'minimal PS': use a small number of manually selected covariates for the propensity score model

cmAnalysis3 <- CohortMethod::createCmAnalysis(analysisId = 3,
                                              description = "Min PS stratified",
                                              getDbCohortMethodDataArgs = getDbCmDataArgsWithoutBphMeds,
                                              createStudyPopArgs = createStudyPopArgs,
                                              createPs = TRUE,
                                              createPsArgs = createMinPsArgs,
                                              stratifyByPs = TRUE,
                                              stratifyByPsArgs = stratifyByPsArgs,
                                              fitOutcomeModel = TRUE,
                                              fitOutcomeModelArgs = fitPsOutcomeModelArgs)

# Analysis 4 -- minimal PS matching

cmAnalysis4 <- CohortMethod::createCmAnalysis(analysisId = 4,
                                              description = "Min PS matched",
                                              getDbCohortMethodDataArgs = getDbCmDataArgsWithoutBphMeds,
                                              createStudyPopArgs = createStudyPopArgs,
                                              createPs = TRUE,
                                              createPsArgs = createMinPsArgs,
                                              matchOnPs = TRUE,
                                              matchOnPsArgs = matchByPsArgs,
                                              fitOutcomeModel = TRUE,
                                              fitOutcomeModelArgs = fitPsOutcomeModelArgs)

# Analysis 5 -- Large-scale PS stratification

cmAnalysis5 <- CohortMethod::createCmAnalysis(analysisId = 5,
                                              description = "Full PS stratified",
                                              getDbCohortMethodDataArgs = getDbCmDataArgsWithoutBphMeds,
                                              createStudyPopArgs = createStudyPopArgs,
                                              createPs = TRUE,
                                              createPsArgs = createLargeScalePsArgs,
                                              stratifyByPs = TRUE,
                                              stratifyByPsArgs = stratifyByPsArgs,
                                              fitOutcomeModel = TRUE,
                                              fitOutcomeModelArgs = fitPsOutcomeModelArgs)

# Analysis 6 -- Large-scale PS matching

cmAnalysis6 <- CohortMethod::createCmAnalysis(analysisId = 6,
                                              description = "Full PS matched",
                                              getDbCohortMethodDataArgs = getDbCmDataArgsWithoutBphMeds,
                                              createStudyPopArgs = createStudyPopArgs,
                                              createPs = TRUE,
                                              createPsArgs = createLargeScalePsArgs,
                                              matchOnPs = TRUE,
                                              matchOnPsArgs = matchByPsArgs,
                                              fitOutcomeModel = TRUE,
                                              fitOutcomeModelArgs = fitPsOutcomeModelArgs)

cmAnalysisList <- list(cmAnalysis1,cmAnalysis3,cmAnalysis4,cmAnalysis5,cmAnalysis6)

CohortMethod::saveCmAnalysisList(cmAnalysisList, "cmAnalysisList.json")

