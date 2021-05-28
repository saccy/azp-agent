FROM centos:latest
LABEL maintainer='saccy'
LABEL description='Azure DevOps build agent centos 8 base container'

#Save latest version number to a file for later use.
ENV agent_version /tmp/agent_version
# RUN curl -Ls https://github.com/microsoft/azure-pipelines-agent/releases | grep '<td>Linux x64</td>' -A1 | head -2 | cut -d '/' -f5 | tail -1 > ${agent_version}
RUN curl -Ls https://github.com/microsoft/azure-pipelines-agent/releases/latest | grep '<td>Linux x64</td>' -A1 | head -2 | cut -d '/' -f5 | tail -1 > ${agent_version}

#Install required prereqs
RUN yum install -y git
RUN yum install -y wget
RUN yum install -y compat-openssl10

#Install ADO build agent + dependencies
RUN mkdir -p /opt/ado_agent/build_scripts
WORKDIR /opt/ado_agent/
RUN wget https://vstsagentpackage.azureedge.net/agent/$(cat ${agent_version})/vsts-agent-linux-x64-$(cat ${agent_version}).tar.gz --no-check-certificate
COPY ./files/connect.sh ./connect.sh
RUN chmod 755 ./connect.sh
RUN tar xvzf vsts-agent-linux-x64-$(cat ${agent_version}).tar.gz

#Hack the dependency installation to work with RHEL/CentOS 8
RUN sed -ie 's/^                yum install -y openssl-libs libcurl krb5-libs zlib libicu/                yum install -y openssl-libs krb5-libs zlib libicu/g' ./bin/installdependencies.sh
RUN sed -ie 's/^                yum install -y wget && wget -P \/etc\/yum.repos.d\/ https:\/\/packages.efficios.com\/repo.files\/EfficiOS-RHEL7-x86-64.repo && rpmkeys --import https:\/\/packages.efficios.com\/rhel\/repo.key && yum updateinfo && yum install -y lttng-ust/                yum install -y lttng-ust/g' ./bin/installdependencies.sh
RUN yum install -y lttng-ust
RUN ./bin/installdependencies.sh

#The container will connect to ADO when it is run. See ./run.sh
ENTRYPOINT ["/bin/bash", "-c", "/opt/ado_agent/connect.sh ${*}", "--"]
