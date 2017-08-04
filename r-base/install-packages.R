## to execute: R CMD BATCH install-packages.R
# a few routines to install
InstalledPackage <- function(package)
{
    available <- suppressMessages(suppressWarnings(sapply(package, require, quietly = TRUE, character.only = TRUE, warn.conflicts = FALSE)))
    missing <- package[!available]
    if (length(missing) > 0)
        return(FALSE)
    return(TRUE)
}

CRANChoosen <- function()
{
    return(getOption("repos")["CRAN"] != "@CRAN@")
}

UsePackage <- function(package, defaultCRANmirror = "http://cran.at.r-project.org")
{
    if(!InstalledPackage(package))
    {
        if(!CRANChoosen())
        {
                options(repos = c(CRAN = defaultCRANmirror))
        }

        suppressMessages(suppressWarnings(install.packages(package, Sys.getenv("R_LIBS_USER"))))
        if(!InstalledPackage(package)) return(FALSE)
    }
    return(TRUE)
}

libraries <- c("evaluate",
               "base64enc",
               "devtools",
               "libcurl-devel",
               "curl",
               "RCurl",
               "ggplot2",
               "dplyr",
               "pryr",      # pryer helps to search namespace (dply and SparkR conflict)
               "knitr",
               "scales"     # for transparency
)
for(library in libraries)
{
    if(!UsePackage(library))
    {
        stop("LoadLibrary Error!", library)
    }
}

library('devtools');
install_github('IRkernel/repr')"

# grind it out the long way
#install.packages(c("evaluate", "base64enc", "devtools"), Sys.getenv("R_LIBS_USER"), repos = "http://lib.stat.cmu.edu/R/CRAN/" )
#install.packages(c("libcurl-devel", "curl", "RCurl"), Sys.getenv("R_LIBS_USER"), repos = "http://lib.stat.cmu.edu/R/CRAN/" )
#install.packages(c("scales", "ggplot2", "dplyr", "plyr", "knitr"), Sys.getenv("R_LIBS_USER"), repos = "http://lib.stat.cmu.edu/R/CRAN/" )