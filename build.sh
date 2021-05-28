#!/bin/bash

docker build . -t saccy/azp-agent:latest

docker push saccy/azp-agent:latest
