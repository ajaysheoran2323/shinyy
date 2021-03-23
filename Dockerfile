FROM rocker/r-base:latest
RUN mkdir -p /01_data
RUN mkdir -p /02_code
RUN mkdir -p /03_output
COPY 182-google-charts/install_packages.R /02_code/install_packages.R
COPY 182-google-charts/app.R /02_code/app.R
RUN Rscript /02_code/install_packages.R
COPY 182-google-charts/healthexp.Rds /02_code/
WORKDIR /02_code/
#install missing package.
RUN Rscript -e 'install.packages("devtools")'
RUN apt-get update && apt-get install -y libxml2-dev && apt-get install -y libssl-dev && apt-get install -y curl && apt-get install -y unixodbc-dev && apt-get install -y libsqlite3-dev
RUN apt-get install -y libcurl4-openssl-dev && apt-get install -y libmariadbd-dev && apt-get install -y libssh2-1-dev
#CMD Rscript /02_code/app.R
CMD ["R", "-e", "shiny::runApp('/02_code/', host = '0.0.0.0', port=80"]
