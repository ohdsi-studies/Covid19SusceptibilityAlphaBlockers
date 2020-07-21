library(Covid19SusceptibilityAlphaBlockers)

# Maximum number of cores to be used:
maxCores <- parallel::detectCores()

# The folder where the study intermediate and result files will be written:
outputFolder <- paste0(path.expand("~"), "/Covid19SusceptibilityAlphaBlockersTest")

# Details for connecting to the server:
connectionDetails <- DatabaseConnector::createConnectionDetails(dbms = "pdw",
                                                                server = "JRDUSAPSCTL01",
                                                                user = NULL,
                                                                password = NULL,
                                                                port = "17001")

# The name of the database schema where the CDM data can be found:
cdmDatabaseSchema <- "CDM_IBM_MDCR_V1192.dbo"

# The name of the database schema and table where the study-specific cohorts will be instantiated:
cohortDatabaseSchema <- "scratch.dbo"
cohortTable <- "mschuemi_skeleton"

# Some meta-information that will be used by the export function:
databaseId <- "MDCR"
databaseName <- "MarketScan Medicare"
databaseDescription <- "MarketScan Medicare"

# For Oracle: define a schema that can be used to emulate temp tables:
oracleTempSchema <- NULL

execute(connectionDetails = connectionDetails,
        cdmDatabaseSchema = cdmDatabaseSchema,
        cohortDatabaseSchema = cohortDatabaseSchema,
        cohortTable = cohortTable,
        oracleTempSchema = oracleTempSchema,
        outputFolder = outputFolder,
        databaseId = databaseId,
        databaseName = databaseName,
        databaseDescription = databaseDescription,
        createCohorts = TRUE,
        synthesizePositiveControls = FALSE,
        runAnalyses = TRUE,
        runDiagnostics = FALSE,
        packageResults = FALSE,
        makePlots = FALSE,
        maxCores = 1)

