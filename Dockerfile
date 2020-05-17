FROM alpine:latest
LABEL maintainer='saccy@headsup.dev'
LABEL description='Azure DevOps build agent alpine base container'

#Install required prereqs
RUN apk add bash
RUN apk add git 
RUN apk add wget
RUN apk add curl

RUN apk add --no-cache \
    ca-certificates \
    \
    # .NET Core dependencies
    krb5-libs \
    libgcc \
    libintl \
    libssl1.1 \
    libstdc++ \
    zlib

#Save latest version number to a file for later use (found here: https://github.com/microsoft/azure-pipelines-agent/releases)
ENV agent_version /tmp/agent_version
RUN curl -s https://github.com/microsoft/azure-pipelines-agent/releases | grep '<td>Linux x64</td>' -A1 | head -2 | cut -d '/' -f5 | tail -1 > ${agent_version}

#Install ADO build agent + dependencies
RUN mkdir -p /opt/ado_agent/build_scripts
WORKDIR /opt/ado_agent/
RUN wget https://vstsagentpackage.azureedge.net/agent/$(cat ${agent_version})/vsts-agent-linux-x64-$(cat ${agent_version}).tar.gz --no-check-certificate 
COPY ./files/connect.sh ./connect.sh
RUN chmod 755 ./connect.sh
RUN tar xvzf vsts-agent-linux-x64-$(cat ${agent_version}).tar.gz

RUN apk add lttng-ust
RUN apk add gcompat
ENV DOTNET_RUNNING_IN_CONTAINER=true
# RUN ./bin/installdependencies.sh

#The container will connect to ADO when it is run. See ./run.sh
ENTRYPOINT ["/bin/bash", "-c", "/opt/ado_agent/connect.sh ${*}", "--"]

# FROM node:10-alpine

# RUN apk add --no-cache --virtual .pipeline-deps readline linux-pam \
#   && apk add bash sudo shadow \
#   && apk del .pipeline-deps

# LABEL "com.azure.dev.pipelines.agent.handler.node.path"="/usr/local/bin/node"

# CMD [ "node" ]
