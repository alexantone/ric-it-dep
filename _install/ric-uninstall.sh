#!/bin/bash

helm list | grep -o -P 'r1-[^\ \t]*' | xargs helm del --purge

