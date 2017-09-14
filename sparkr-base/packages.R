## to execute: R CMD BATCH install-packages.R

# grind it out the long way
install.packages(c("evaluate", "base64enc", "devtools"), Sys.getenv("R_LIBS_USER"), repos = "http://lib.stat.cmu.edu/R/CRAN/" )
install.packages(c("libcurl-devel", "curl", "RCurl"), Sys.getenv("R_LIBS_USER"), repos = "http://lib.stat.cmu.edu/R/CRAN/" )
install.packages(c("scales", "ggplot2", "dplyr", "plyr", "knitr"), Sys.getenv("R_LIBS_USER"), repos = "http://lib.stat.cmu.edu/R/CRAN/" )

library('devtools');
install_github('IRkernel/repr')"
