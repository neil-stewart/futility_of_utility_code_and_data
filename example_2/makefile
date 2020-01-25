analysis.html: analysis.Rmd
	Rscript -e 'library(rmarkdown); rmarkdown::render("analysis.Rmd", "html_document")'

analysis.R: analysis.Rmd
	Rscript -e 'library(knitr); knitr::purl("analysis.Rmd", documentation=2)'

