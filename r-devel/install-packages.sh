#!/usr/bin/env r
# install.r digest RcppCNPy
if (is.null(argv) | length(argv)<1) {
  cat("Usage: installr.r pkg1 [pkg2 pkg3 ...]\n")
  q()
}

repos <- "http://cran.rstudio.com"

#R_USER_LIBS
lib.loc <- "/usr/local/lib/R/site-library"

install.packages(argv, lib.loc, repos)
