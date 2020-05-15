# ado-build-agent
CentOS 8 based Azure DevOps (ADO) build agent image.

### How to use
You'll need the following in order to run this container:
- `AZP_URL` ADO project URL
- `AZP_TOKEN` <a href="https://docs.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate?view=azure-devops&tabs=preview-page" target="_blank">ADO personal access token (PAT)</a><br>
- `AZP_POOL` <a href="https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/pools-queues?view=azure-devops&tabs=yaml%2Cbrowser" target="_blank">ADO agent pool</a><br>
- `AZP_AGENT_NAME` A name for your agent (whatever you'd like!)

To run normally:
```
docker run \
    -e AZP_URL='https://dev.azure.com/my_project' \
    -e AZP_TOKEN='12345abcde' \
    -e AZP_POOL='my_pool' \
    -e AZP_AGENT_NAME='my_agent' \
    saccy/ado-build-agent
```

To run behind a proxy that requires username and password:
```
docker run \
    -e AZP_URL='https://dev.azure.com/my_project' \
    -e AZP_TOKEN='12345abcde' \
    -e AZP_POOL='my_pool' \
    -e AZP_AGENT_NAME='my_agent' \
    -e PROXY_URL='https://my_proxy:8000' \
    -e PROXY_USER='my_proxy_user' \
    -e PROXY_PASS='12345abcde' \
    saccy/ado-build-agent
```

To run behind a proxy that does *not* require authentication:
```
docker run \
    -e AZP_URL='https://dev.azure.com/my_project' \
    -e AZP_TOKEN='12345abcde' \
    -e AZP_POOL='my_pool' \
    -e AZP_AGENT_NAME='my_agent' \
    -e PROXY_URL='https://my_proxy:8000' \
    saccy/ado-build-agent
```

### TODO
- Add alpine base

### Connect
twitter: <a href="https://twitter.com/the_last_saccy" target="_blank">@the_last_saccy</a><br>
blog: <a href="https://blog.headsup.dev" target="_blank">blog.headsup.dev</a><br>
