#!/bin/sh

find . -type f \( -name "*.R" -o -name "*.Rd" -o -name "*.Rmd" \) -print0 | xargs -0 sed -i '' -e 's/Covid19IncidenceAlphaBlockers/Covid19SusceptibilityAlphaBlockers/g'
additional_files="readme.md HydraConfig.json inst/settings/StudySpecification.json"
sed -i '' -e 's/Covid19IncidenceAlphaBlockers/Covid19SusceptibilityAlphaBlockers/g' $additional_files
git mv man/Covid19IncidenceAlphaBlockers.Rd man/Covid19SusceptibilityAlphaBlockers.Rd
git mv Covid19IncidenceAlphaBlockers.Rproj Covid19SusceptibilityAlphaBlockers.Rproj
