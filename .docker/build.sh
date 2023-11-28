
docker build \
    -f Dockerfile.base \
    -t anthesevenants/lingquizticsanalysis:base .

docker build \
    -f Dockerfile.rstudio \
    -t anthesevenants/lingquizticsanalysis:rstudio .