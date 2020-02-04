#!/bin/bash

# Based on:
#   https://nexus.akraino.org/content/sites/logs/att/job/Install_RIC_on_OpenEdge1/206/console-timestamp.log.gz
#
# REC_integration private repo not available (ssh://attjenkins@gerrit.mtlab.att-akraino.org:29418/rec_integration)
#
# See also:
#   https://jira.akraino.org/browse/REC-80

set -x
# Workdir should be /opt/ric:
# /opt/ric
#      ├── dep              # from oran-sc it/dep repo
#      ├── rec_images       # images for pre-loading (from ric.tar)
#      └── REC_integration  # from AT&T private repo
# cd /opt/ric

echo '************ Preloading images ************'
# bash ./dep/bin/preload-images \
#      -p /opt/ric/ric_image \
#      -d registry.kube-system.svc.rec.io:5555/ric

echo '************ Deploying DANM Networks ************'
# if [ -d /opt/ric/REC_integration/danm/Middletown_OE1 ]; then
#    ( cd ./REC_integration/danm/Middletown_OE1 && \
#      ls danmnet40-e2adapter.yaml danmnet40-portal.yaml danmnet40-ricplatform.yaml \
#         | xargs -n 1 kubectl apply -f )
# fi
#
## Output:
##  clusternetwork.danm.k8s.io/default configured
##  clusternetwork.danm.k8s.io/e2agent created
##  clusternetwork.danm.k8s.io/e2adapter created
##  clusternetwork.danm.k8s.io/default unchanged
##  clusternetwork.danm.k8s.io/ext created
##  clusternetwork.danm.k8s.io/ext2 created
##  clusternetwork.danm.k8s.io/ew created
##  clusternetwork.danm.k8s.io/default unchanged
##  clusternetwork.danm.k8s.io/ran created
##  clusternetwork.danm.k8s.io/ext1 created
##  clusternetwork.danm.k8s.io/ew configured


echo '************ Creating RIC K8S Namespaces ************'
echo ricinfra ricplt ricaux ricxapp | xargs -n 1 kubectl create ns


echo '************ Apply RBAC  ************'
# kubectl apply -f /opt/ric/REC_integration/ricplt-role.yaml
## Output:
##  clusterrole.rbac.authorization.k8s.io/ricplt-system-tiller created
##  clusterrolebinding.rbac.authorization.k8s.io/ricplt-system-tiller created

# kubectl apply -f /opt/ric/REC_integration/rbac.yaml
## Output:
##  clusterrole.rbac.authorization.k8s.io/ricplt-system-tiller configured
##  clusterrolebinding.rbac.authorization.k8s.io/ricplt-system-tiller unchanged

# kubectl apply -f /opt/ric/REC_integration/rbac2.yaml
## Output:
##  clusterrole.rbac.authorization.k8s.io/ricplt-system-tiller configured
##  clusterrolebinding.rbac.authorization.k8s.io/ricplt-system-tiller unchanged

kubectl apply -f rbac-config.yaml

echo '************ Deploying RIC Infrastructure ************'
# Derive infra.yaml from RECIPE_EXAMPLE/RIC_INFRA_RECIPE_EXAMPLE
[ -f infra.yaml ]  && bash -e /opt/ric/dep/bin/deploy-ric-infra ./infra.yaml
sleep 5

# Selected output:
#   Deploying RIC infra components [kong]
#       NAME                NAMESPACE
#       r1-kong             ricinfra
#
#   Deploying RIC infra components [credential]
#       NAME                    NAMESPACE
#       r1-ricplt-credential    ricplt
#       r1-ricxapp-credential   ricxapp
#       r1-ricaux-credential    ricaux
#       r1-ricinfra-credential  ricinfra
#
#   Deploying RIC infra components [xapp-tiller]
#       NAME                    NAMESPACE
#       r1-xapp-tiller          ricinfra


echo '************ Deploying RIC Platform ************'
# Derive platform.yaml from RECIPE_EXAMPLE/RIC_PLATFORM_RECIPE_EXAMPLE
[ -f platform.yaml ]  && bash -e /opt/ric/dep/bin/deploy-ric-platform ./platform.yaml
sleep 5

# Selected output:
#   Deploying RIC infra components [appmgr rtmgr dbaas1 e2mgr e2term a1mediator submgr vespamgr rsm jaegeradapter]
#       NAME                NAMESPACE
#       r1-appmgr           ricplt
#       r1-rtmgr            ricplt
#       r1-dbaas1           ricplt
#       r1-e2mgr            ricplt
#       r1-e2term           ricplt
#       r1-a1mediator       ricplt
#       r1-submgr           ricplt
#       r1-vespamgr         ricplt
#       r1-rsm              ricplt
#       r1-jaegeradapter    ricplt
#
#   Deploying RIC infra components [extsvcplt]
#       NAME           NAMESPACE
#       r1-extsvcplt   ricplt
#

# DONE
# + exit 0
# Performing Post build task...
