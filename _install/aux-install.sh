#!/bin/bash


set -x
# Workdir should be /opt/ric:
# /opt/ric
#      ├ dep              # from oran-sc it/dep repo
#      ├ rec_images       # images for pre-loading (from ric.tar)
#      └ REC_integration  # from AT&T private repo
# cd /opt/ric

echo '************ Creating AUX K8S Namespaces ************'
echo auxinfra ricplt ricaux ricxapp | xargs -n 1 kubectl create ns



echo '************ Deploying AUX Infrastructure ************'
# Derive infra.yaml from RECIPE_EXAMPLE/RIC_INFRA_RECIPE_EXAMPLE
[ -f aux-infra.yaml ]  && bash -e /opt/ric/dep/bin/deploy-ric-infra ./aux-infra.yaml
sleep 5

echo '************ Deploying AUX ************'
# Derive platform.yaml from RECIPE_EXAMPLE/RIC_PLATFORM_RECIPE_EXAMPLE
[ -f platform.yaml ]  && bash -e /opt/ric/dep/bin/deploy-ric-aux ./aux.yaml
sleep 5

