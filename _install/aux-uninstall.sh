#!/bin/bash

helm list | grep -o -P 'r2-[^\ \t]*' | xargs helm del --purge

# FIXME: alav: previous installations might leave behind leftover secrets
# which break tiller-secret-generator reinstallation with:
# Error from server (AlreadyExists): secrets "secret-helm-client-ricxapp" already exists
# + kubectl label secret secret-helm-client-ricxapp 'app=helm' 'name=secret-helm-client-ricxapp
# 'app' already has a value (helm), and --overwrite is false
# 'name' already has a value (secret-helm-client-ricxapp), and --overwrite is false


kubectl delete secrets -n auxinfra secret-helm-client-ricxapp secret-tiller-ricxapp

