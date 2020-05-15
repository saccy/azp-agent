#!/bin/bash

docker build . -t hudev/azp-agent:centos8

docker push hudev/azp-agent:centos8  
