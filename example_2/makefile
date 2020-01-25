analysis.html: analysis.Rmd
	Rscript -e 'library(rmarkdown); rmarkdown::render("analysis.Rmd", "html_document")'

analysis.R: analysis.Rmd
	Rscript -e 'library(knitr); knitr::purl("analysis.Rmd", documentation=2)'

make_clean_data.html: make_clean_data.Rmd
	Rscript -e 'library(rmarkdown); rmarkdown::render("make_clean_data.Rmd", "html_document")'

make_clean_data.R: make_clean_data.Rmd
	Rscript -e 'library(knitr); knitr::purl("make_clean_data.Rmd", documentation=2)'

