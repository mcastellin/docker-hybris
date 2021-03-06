# docker-hybris    ![Test](https://github.com/mcastellin/docker-hybris/workflows/Test/badge.svg)

This project generates a docker image with a specific SAP Hybris Commerce, running on `ubuntu:16.04`. Please, note that **the generated container is not meant for productive environments**.

## Why another Dockerfile for Hybris?
There are plenty of projects around to build a wide variety of docker images for Hybris Commerce Suite, then why am I creating another one?
This project is **specifically meant for developers and to run on their development machines**. You typically have to deal with several different Hybris installations on different platform versions. Using Docker comes naturally when you need to have your projects and software dependencies organized.

## Generating your own image
1. Copy your Hybris bundle archive into the `bundles/` directory. Docker needs to have all files at hand (under the same root as `Dockerfile`) to build its images
2. Open a terminal and navigate to `bin/` directory
3. Run `dh-gen` script providing Hybris installation package with `--bundle` parameter to build your image. Here is an exmample:
```bash
$ bin/dh-gen.sh --bundle <YOUR_HYBRIS_VERSION>.zip
```

#### Optional build parameters
###### --name
Specify `name` and `tag` for the container image [default value is `ydocker:latest`]. This comes handy when generating multiple Hybris images with different versions:
```bash
$ bin/dh-gen.sh --bundle <YOUR_HYBRIS_VERSION>.zip --name "mydockerimage:6.0.1"
```

In case you don't specify an image tag, docker will automatically apply ":latest". The following will generate "mydockerimage:latest" image
```bash
$ bin/dh-gen.sh --bundle <YOUR_HYBRIS_VERSION>.zip --name "mydockerimage"
```

###### --recipe
By default, the container will be generated using `b2c_acc` recipe. You may need to specify a different recipe using the `--recipe` option:
```bash
$ bin/dh-gen.sh --bundle <YOUR_HYBRIS_VERSION>.zip --recipe <the_hybris_recipe>
```
To get a full list of recipes available, please refer to the specific `Installer Recipe Reference` page for your SAP Hybris version

## Running the container
Once you have generated the Hybris container using `dh-gen` command, you can use it to run your custom codebase and configuration.

To get the full list of available docker containers on your machine, run `docker images` on a terminal window.
```bash
$ docker images
REPOSITORY                          TAG                 IMAGE ID            CREATED             SIZE
ydocker                             6.0.0.7             02848bd45a5c        8 days ago          5.48GB
ydocker                             5.5.1               c63421230a68        12 days ago         8.64GB
ubuntu                              16.04               14f60031763d        11 days ago         120MB
mysql                               5.5                 33efe4d711c7        2 months ago        256MB
```

You can run your own codebase directly in the Hybris container with this setup:
```bash
$ docker run -d --user=hybrisuser --name <MY_CONTAINER_NAME> \
  -p 9001:9001 -p 9002:9002 \
  -v $PWD/hybrisdata/:/opt/hybris/data/ \
  -v /path/to/hybris/bin/custom/:/opt/hybris/bin/custom/ \
  -v /path/to/hybris/config/:/opt/hybris/config/ \
  <DOCKER_IMAGE>:<TAG>
```
Here is the command in details:
* `docker run -d --user=hybrisuser --name <MY_CONTAINER_NAME>` tells docker to run a new container from `<DOCKER_IMAGE>:<TAG>` image as a non-root user called 'hybrisuser' and name it `<MY_CONTAINER_NAME>`. 'hybrisuser' is part of the docker image, so don't change it.  `-d` option is to run our new container in background mode
* `-p 9001:9001 -p 9002:9002` binds port 9001 of local machine to container's port 9001. Same applies for port 9002
* `-v $PWD/hybrisdata/:/opt/hybris/data/` binds volume `/opt/hybris/data` with a local machine's folder `hybrisdata` in the current directory (you can specify any directory with its full path also). This will store all data into the specified folder, preserving it even if you delete the container. If you need to recreate the container from scratch you can simply bind the same directory and have your data available.
* `-v /path/to/hybris/bin/custom/:/opt/hybris/bin/custom/` binds your `bin/custom` project directory with the same in the Hybris container. This option allows you to run your custom codebase inside the container
* `-v /path/to/hybris/config/:/opt/hybris/config/` binds your custom `config` directory with the same in the container.

# Building SAP Commerce with the new build command
We are implementing a new image build process for compatibility with the latest SAP Commerce versions and Java 11. 
As part of the refactoring, the new build scripts will be more focused on creating images that can not only be used
for local development but also in CI/CD pipelines.

Here are some of the advantages:
- Minimising docker image size to optimise transfer times between docker registries
- Two-layered build. SAP Commerce customizations will build separately for faster image creation time

## Building with the new build scripts
To build the SAP Commerce image run the build script `bin/build_img.sh` and provide the path of the SAP Commerce bundle downloaded from SAP Marketplace.
For example: 
```bash
bin/build.sh path/to/hybris/bundle.zip
```

> For now the build script supports SAP Commerce bundles as zip files only.

## Providing custom installation scripts
If your SAP Commerce installation needs custom setup you can provide your own installation scripts in the `ybase/custom-scripts/` directory.
The setup scripts will run during the docker build stage for the `ybase` image. They need to be provided as executable bash scripts with the `.sh` extension 
and placed in the `ybase/custom-scripts/` directory.

You can provide multiple installation scripts. If multiple `.sh` files are found in the `ybase/custom-scripts/` directory they will run in 
order (e.g. `01_script.sh`, `02_script.sh`, `03_script.sh`, etcetera).

A template script is provided in the `ybase/custom-scripts/` directory, you can copy the `01_custom-install.sh.template` and rename it so the extension is `.sh`.

# License
This project is released under the [MIT License](LICENSE.md)
