#!/bin/bash
set -e

export AGENT_ALLOW_RUNASROOT="1"

if [[ ! -n $AZP_URL || ! -n $AZP_TOKEN || ! -n $AZP_POOL || ! -n $AZP_AGENT_NAME ]]; then
    echo "Missing a required parameter"
    exit 1
fi

if [[ -n $PROXY_URL && -n $PROXY_USER && -n $PROXY_PASS ]]; then
    echo "Connecting to ADO server: $AZP_URL
agent pool: $AZP_POOL
agent name: $AZP_AGENT_NAME
proxy url: $PROXY_URL
proxy user: $PROXY_USER"
    ./config.sh \
        --unattended \
        --url $AZP_URL \
        --auth pat \
        --token $AZP_TOKEN \
        --pool $AZP_POOL \
        --agent $AZP_AGENT_NAME \
        --replace \
        --acceptTeeEula \
        --proxyurl $PROXY_URL \
        --proxyusername $PROXY_USER \
        --proxypassword $PROXY_PASS
elif [[ -n $PROXY_URL && ! -n $PROXY_USER && ! -n $PROXY_PASS ]]; then 
    echo "Connecting to ADO server: $AZP_URL
agent pool: $AZP_POOL
agent name: $AZP_AGENT_NAME
proxy url: $PROXY_URL"
    ./config.sh \
        --unattended \
        --url $AZP_URL \
        --auth pat \
        --token $AZP_TOKEN \
        --pool $AZP_POOL \
        --agent $AZP_AGENT_NAME \
        --replace \
        --acceptTeeEula \
        --proxyurl $PROXY_URL
elif [[ ! -n $PROXY_URL && ! -n $PROXY_USER && ! -n $PROXY_PASS ]]; then 
    echo "Connecting to ADO server: $AZP_URL
agent pool: $AZP_POOL
agent name: $AZP_AGENT_NAME"
    ./config.sh \
        --unattended \
        --url $AZP_URL \
        --auth pat \
        --token $AZP_TOKEN \
        --pool $AZP_POOL \
        --agent $AZP_AGENT_NAME \
        --replace \
        --acceptTeeEula
fi

./run.sh
