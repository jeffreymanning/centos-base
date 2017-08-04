FROM jeffreymanning/r-base

MAINTAINER Jeff Manning

USER root

#install the basic packages, must install sudo - some downstream consumers cannot run as root
RUN yum clean all && \
    yum -y update && \
    yum clean all

# setup some environment stuff - https://cran.r-project.org/mirrors.html
# https://cran.cnr.berkeley.edu/
# http://cran.stat.ucla.edu/
# http://lib.stat.cmu.edu/R/CRAN/
ARG CRAN_REPO=http://lib.stat.cmu.edu/R/CRAN/
ARG BIO_REPO=https://bioconductor.org/

# add some base packages...  but where?  we are root?  Need to be seen by all?
#RUN R -e "source('https://bioconductor.org/biocLite.R')" && \
#    /usr/local/bin/install
.r --error \
#    --deps TRUE \
#    evaluate \
#    base64enc' \
#    libcurl-devel' \
#    curl' \
#    devtools' \
#    RCurl' \
#    scales' \
#    ggplot2' \
#    nycflights13' \
#    dplyr' \
#    plyr' \
#    knitr

RUN /usr/bin/Rscript --slave --no-save --no-restore-history -e "install.packages(pkgs=c('devtools'), repos='${CRAN_REPO}')"
RUN /usr/bin/Rscript --slave --no-save --no-restore-history -e "install.packages(pkgs=c('evaluate'), repos='${CRAN_REPO}')"
RUN /usr/bin/Rscript --slave --no-save --no-restore-history -e "install.packages(pkgs=c('base64enc'), repos='${CRAN_REPO}')"
RUN /usr/bin/Rscript --slave --no-save --no-restore-history -e "install.packages(pkgs=c('libcurl-devel'), repos='${CRAN_REPO}')"
RUN /usr/bin/Rscript --slave --no-save --no-restore-history -e "install.packages(pkgs=c('curl'), repos='${CRAN_REPO}')"
RUN /usr/bin/Rscript --slave --no-save --no-restore-history -e "install.packages(pkgs=c('RCurl'), repos='${CRAN_REPO}')"
RUN /usr/bin/Rscript --slave --no-save --no-restore-history -e "library('devtools'); install_github('IRkernel/repr')"

COPY packages.R /tmp/
COPY install-packages.R /tmp/
#RUN R CMD BATCH /tmp/packages.R

#### Define default command.
CMD ["R"]

