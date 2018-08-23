# package-build-docker

This repository contains the sources for docker-images that we use
to build rpms (and possibly other packages in the future)

## Branches / Tags

This repository contains a branch for each tag that is used on the 
docker-image. It is configured in https://hub.docker.com as 
Automated Build.



## Using this image

```
docker run -t package-build intelligentviews/package-build-docker bash
```

