#!/bin/sh

find . -type f \( -name "*.R" -o -name "*.Rd" -o -name "*.Rmd" \) -print0 | xargs -0 sed -i '' -e 's/Covid19IncidenceRasInhibitors/Covid19IncidenceAlphaBlockers/g'
additional_files="readme.md HydraConfig.json inst/settings/StudySpecification.json"
sed -i '' -e 's/Covid19IncidenceRasInhibitors/Covid19IncidenceAlphaBlockers/g' $additional_files
git mv man/Covid19IncidenceRasInhibitors.Rd man/Covid19IncidenceAlphaBlockers.Rd
git mv Covid19IncidenceRasInhibitors.Rproj Covid19IncidenceAlphaBlockers.Rproj
