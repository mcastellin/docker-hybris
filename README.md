# docker-hybris

This generates a docker image with collectd and hybris running on `ubuntu:latest`

## Steps To Install
1. copy the desidered hybris bundle into `bundles/`
1. edit `buildHybrisImage.sh` and change `COMMERCE_SUITE_FILE` variable with the path to your hybris bundle file (e.g. `COMMERCE_SUITE_FILE=bundles/HYBRISCOMM6000P_7-80001481.zip`)
1. go to this repository home directory, where `Dockerfile` is locted with `cd /your/path/to/repo`
1. run docker image generation script with `sh buildHybrisImage.sh`


