# package-build-docker

This repository contains the sources for docker-images that we use
to build rpms (and possibly other packages in the future)

## Branches / Tags

This repository contains a branch for each tag that is used on the 
docker-image. It is configured in https://hub.docker.com as 
Automated Build.

## Using this image

The docker-image contains the following software:

- `rpm-build` for building rpms
- `nodejs`, `npm` and `yarn` for running nodejs

In case you have a project that builds rpms using the [grunt-easy-rpm](https://www.npmjs.com/package/grunt-easy-rpm] package, you can use
the following `.gitlab-ci.yml` to run the build.

```yml
image: docker.io/intelligentviews/package-build-docker:centos7-node8

stages:
  - build

cache:
  paths:
  - node_modules/
  - .yarn

build:
  stage: build
  script:
    - yarn install --pure-lockfile --cache-folder .yarn
    # assuming grunt is in the dev-dependencies
    - npx grunt build

  artifacts:
    name: build
    paths:
      - my-rpm-package-*.rpm
```

## User and access-rights

By default: The "script" is not run as "root" by as "user" (that's the username). This is a security measure.

If you need to install additional packages, you can do this by [overriding  the entry-point](https://docs.gitlab.com/ce/ci/docker/using_docker_images.html#overriding-the-entrypoint-of-an-image), but don't forget to change the user before executing yarn, npm or node

```yml
image:
  # Override the entrypoint to prevent changing to "user" 
  name: docker.io/intelligentviews/package-build-docker:centos7-node8
  entrypoint: [""]

stages:
  - build

cache:
  paths:
  - node_modules/
  - .yarn

build:
  stage: build
  script:
    # Run a command as root
    - yum install imagemagick
    # Change the user
    - /entrypoint.sh yarn install --pure-lockfile --cache-folder .yarn
    # assuming grunt is in the dev-dependencies
    - /entrypoint.sh npx grunt build

  artifacts:
    name: build
    paths:
      - my-rpm-package-*.rpm
```


  
