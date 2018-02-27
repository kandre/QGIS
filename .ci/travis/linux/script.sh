###########################################################################
#    script.sh
#    ---------------------
#    Date                 : March 2016
#    Copyright            : (C) 2016 by Matthias Kuhn
#    Email                : matthias at opengis dot ch
###########################################################################
#                                                                         #
#   This program is free software; you can redistribute it and/or modify  #
#   it under the terms of the GNU General Public License as published by  #
#   the Free Software Foundation; either version 2 of the License, or     #
#   (at your option) any later version.                                   #
#                                                                         #
###########################################################################

set -e



mkdir -p $CCACHE_DIR

if [[ $DOCKER_QGIS_IMAGE_PUSH =~ true ]]; then
  DIR=$(git rev-parse --show-toplevel)/.docker
  pushd ${DIR}
  echo "${bold}Building QGIS Docker image...${endbold}"
  docker build --build-arg CACHE_DIR=/root/.ccache --cache-from "qgis/qgis:${DOCKER_TAG}" -t "qgis/qgis:${DOCKER_TAG}" -f qgis.dockerfile .
  if [[ $DOCKER_QGIS_IMAGE_PUSH =~ true ]]; then
    echo "${bold}Pushing image to docker hub...${endbold}"
    docker login -u="$DOCKER_USERNAME" -p="$DOCKER_PASSWORD"
    docker push "qgis/qgis:${DOCKER_TAG}"
  fi
  popd
else
  docker-compose -f $DOCKER_COMPOSE run --rm qgis-deps
fi
