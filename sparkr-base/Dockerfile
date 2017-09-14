#FROM jeffreymanning/centos-base
# this is geared towards spark environment
FROM jeffreymanning/spark-api
LABEL maintainer="JWM"

USER root

#install the basic packages, must install sudo - some downstream consumers cannot run as root
RUN yum clean all && \
    yum -y update && \
    yum clean all && \
    rm -rf /var/cache/yum

# epel installed in sprk-base
###  R lives in the epel-release, https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm or
# RUN yum install -y epel-release && yum clean all
# R-${R_BASE_VERSION} R-core-${R_BASE_VERSION} R-core-devel-${R_BASE_VERSION} R-devel-${R_BASE_VERSION} && \
#R R-core R-core-devel R-devel R-Rcpp R-Rcpp-devel
# # helpers for R package downloading: libcurl libcurl-devel openssl openssl-devel gnutls gnutls-devel
RUN yum -y install \
           libicu libicu-devel blas blas-devel lapack lapack-devel libxml2 libxml2-devel texinfo texinfo-tex texlive-epsf \
           libcurl libcurl-devel openssl openssl-devel gnutls gnutls-devel \
           R R-core R-core-devel R-devel && \
           yum clean all && \
           rm -rf /var/cache/yum

## alternatively.. using centos
# http://mirror.centos.org/centos/7/os/x86_64/Packages/<package>
# centos/7 is the latest version... but requires managing the version stamps
#RUN yum -y install http://mirror.centos.org/centos/7/os/x86_64/Packages/texlive-epsf-svn21461.2.7.4-38.el7.noarch.rpm
#RUN yum -y install http://mirror.centos.org/centos/7/os/x86_64/Packages/texinfo-5.1-4.el7.x86_64.rpm disable_gpg_check=yes state=present
#RUN yum -y install http://mirror.centos.org/centos/7/os/x86_64/Packages/texinfo-tex-5.1-4.el7.x86_64.rpm disable_gpg_check=yes state=present
#RUN yum -y install http://mirror.centos.org/centos/7/os/x86_64/Packages/blas-3.4.2-5.el7.x86_64.rpm disable_gpg_check=yes state=present
#RUN yum -y install http://mirror.centos.org/centos/7/os/x86_64/Packages/blas-devel-3.4.2-5.el7.x86_64.rpm disable_gpg_check=yes state=present
#RUN yum -y install http://mirror.centos.org/centos/7/os/x86_64/Packages/lapack-3.4.2-5.el7.x86_64.rpm disable_gpg_check=yes state=present
#RUN yum -y install http://mirror.centos.org/centos/7/os/x86_64/Packages/lapack-devel-3.4.2-5.el7.x86_64.rpm disable_gpg_check=yes state=present

## configure
#RUN mkdir -p /etc/R && \
#    touch /etc/R/Rprofile.site && \
#    touch /etc/littler.r && \
#    echo 'options(repos = c(CRAN = "https://cran.rstudio.com/"), download.file.method = "libcurl")' >> /etc/R/Rprofile.site && \
#    echo 'source("/etc/R/Rprofile.site")' >> /etc/littler.r && \
#    echo ln -s /usr/share/doc/littler/examples/install.r /usr/local/bin/install.r && \
#    ln -s /usr/share/doc/littler/examples/install2.r /usr/local/bin/install2.r  && \
#    ln -s /usr/share/doc/littler/examples/installGithub.r /usr/local/bin/installGithub.r && \
#    ln -s /usr/share/doc/littler/examples/testInstalled.r /usr/local/bin/testInstalled.r

### R is installed into /usr/local/lib/R
## Set a default user. Available via runtime flag `--user docker`
## Add user to 'staff' group, granting them write privileges to /usr/local/lib/R/site.library
## User should also have & own a home directory (for rstudio or linked volumes to work properly).
#RUN groupadd staff
#RUN useradd docker \
#	&& chown docker:docker /home/docker \
#    && usermod -aG staff docker

## Add a library directory (for user-installed packages)
RUN mkdir -p /usr/local/lib/R/site-library && \
    chown root:staff /usr/local/lib/R/site-library && \
    chmod g+wx /usr/local/lib/R/site-library

# default package insatalltion to docker location...  will be lost if shutown
ARG R_STUDIO_LIB_SITE=/usr/local/lib/R/site-library

# setup some environment stuff - https://cran.r-project.org/mirrors.html
# https://cran.cnr.berkeley.edu/
# http://cran.stat.ucla.edu/
# http://lib.stat.cmu.edu/R/CRAN/
ARG CRAN_REPO=http://lib.stat.cmu.edu/R/CRAN/
ARG BIO_REPO=https://bioconductor.org/

## Fix library path to confirm (R then .libPaths())
# "R_LIBS=\${R_LIBS-'/usr/local/lib/R/site-library:/usr/share/R/library:/usr/lib64/R/library'}"
ENV R_HOME=/usr/lib64/R
ENV R_LIBS_USER=${R_STUDIO_LIB_SITE}
ENV R_LIBS=${R_LIBS_USER}:/usr/share/R/library:/usr/lib64/R/library
RUN echo 'options(repos = c(CRAN = "${CRAN_REPO}"), download.file.method = "libcurl")' >> ${R_HOME}/etc/Rprofile.site
RUN echo "R_LIBS=\${R_LIBS-'/usr/local/lib/R/site-library:/usr/local/lib/R/library:/usr/lib/R/library'}" >> ${R_HOME}/etc/Renviron

## install littler...  helps with scripting/installing
#RUN /usr/bin/Rscript --slave --no-save --no-restore-history -e "install.packages(pkgs=c('littler'), Sys.getenv('R_LIBS_USER'), repos='${CRAN_REPO}')"
#
##install docopt...  also helps with installation (very cool) - install stringr 1st...
#RUN /usr/bin/Rscript --slave --no-save --no-restore-history -e "install.packages(pkgs=c('stringr'), Sys.getenv('R_LIBS_USER'), repos='${CRAN_REPO}')"
#RUN /usr/bin/Rscript --slave --no-save --no-restore-history -e "install.packages(pkgs=c('docopt'), Sys.getenv('R_LIBS_USER'), repos='${CRAN_REPO}')"
#
## finally devtools to build out of git repos (if necessary)
#RUN /usr/bin/Rscript --slave --no-save --no-restore-history -e "install.packages(pkgs=c('curl'), Sys.getenv('R_LIBS_USER'), repos='${CRAN_REPO}')"
#RUN /usr/bin/Rscript --slave --no-save --no-restore-history -e "install.packages(pkgs=c('R6'), Sys.getenv('R_LIBS_USER'), repos='${CRAN_REPO}')"
#RUN /usr/bin/Rscript --slave --no-save --no-restore-history -e "install.packages(pkgs=c('whisker'), Sys.getenv('R_LIBS_USER'), repos='${CRAN_REPO}')"
#RUN /usr/bin/Rscript --slave --no-save --no-restore-history -e "install.packages(pkgs=c('httr'), Sys.getenv('R_LIBS_USER'), repos='${CRAN_REPO}')"
#RUN /usr/bin/Rscript --slave --no-save --no-restore-history -e "install.packages(pkgs=c('devtools'), Sys.getenv('R_LIBS_USER'), repos='${CRAN_REPO}')"

#### Define default command.
CMD ["R"]

