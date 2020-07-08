cohorts_to_create <- read.csv("inst/settings/CohortsToCreate.csv")
curr_filenames <- cohorts_to_create$name
new_filenames <- sapply(cohorts_to_create$atlasId, function (id) paste("Cohort_Atlas_ID", toString(id), sep = "_"))

# Change SQL and JSON file names
n_file <- length(curr_filenames)
for (i in 1:n_file) {
  print(i)
  file.rename(
    paste0("inst/sql/sql_server/", curr_filenames[i], '.sql'), 
    paste0("inst/sql/sql_server/", new_filenames[i], '.sql')
  )
  file.rename(
    paste0("inst/cohorts/", curr_filenames[i], '.json'), 
    paste0("inst/cohorts/", new_filenames[i], '.json')
  )
}

# Update the csv file
cohorts_to_create$name <- new_filenames
write.csv(cohorts_to_create, "inst/settings/CohortsToCreate.csv")
