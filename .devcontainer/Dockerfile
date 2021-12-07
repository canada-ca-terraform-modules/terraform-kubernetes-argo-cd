# Reference: https://github.com/microsoft/vscode-dev-containers/tree/main/containers/docker-from-docker
FROM mcr.microsoft.com/vscode/devcontainers/base:buster

# [Option] Install zsh
ARG INSTALL_ZSH="true"
# [Option] Upgrade OS packages to their latest versions
ARG UPGRADE_PACKAGES="false"
# [Option] Enable non-root Docker access in container
ARG ENABLE_NONROOT_DOCKER="true"
# [Option] Use the OSS Moby CLI instead of the licensed Docker CLI
ARG USE_MOBY="true"

# Install needed packages and setup non-root user. Use a separate RUN statement to add your
# own dependencies. A user of "automatic" attempts to reuse an user ID if one already exists.
ARG USERNAME=automatic
ARG USER_UID=1000
ARG USER_GID=$USER_UID
COPY library-scripts/*.sh /tmp/library-scripts/
RUN apt-get update \
        && /bin/bash /tmp/library-scripts/common-debian.sh "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" "${UPGRADE_PACKAGES}" "true" "true" \
        # Use Docker script from script library to set things up
        && /bin/bash /tmp/library-scripts/docker-debian.sh "${ENABLE_NONROOT_DOCKER}" "/var/run/docker-host.sock" "/var/run/docker.sock" "${USERNAME}" "${USE_MOBY}" \
        # Clean up
        && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts/

ARG TERRAFORM_VERSION=0.14.8
ARG TFLINT_VERSION=0.25.0
ARG TERRAFORM_DOC_VERSION=0.11.2
ARG GO_VERSION=1.16.1
ARG GOTESTSUM_VERSION=1.6.2
ARG GOLANGCILINT_VERSION=1.38.0
ARG KUBECTL_VERSION=1.18.12

# Make shared download folder
RUN mkdir -p /tmp/downloads

# Install Terraform
RUN curl -sSL -o /tmp/downloads/terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
        && unzip /tmp/downloads/terraform.zip \
        && mv terraform /usr/local/bin

# TFLint
RUN curl -L -o /tmp/downloads/tflint.zip https://github.com/terraform-linters/tflint/releases/download/v${TFLINT_VERSION}/tflint_$(uname)_amd64.zip \
        && unzip /tmp/downloads/tflint.zip \
        && mv tflint /usr/local/bin

# Install Terraform-docs
RUN curl -Lo /tmp/downloads/terraform-docs.tar.gz https://github.com/terraform-docs/terraform-docs/releases/download/v${TERRAFORM_DOC_VERSION}/terraform-docs-v${TERRAFORM_DOC_VERSION}-$(uname)-amd64.tar.gz \
        && tar -xzf /tmp/downloads/terraform-docs.tar.gz \
        && chmod +x terraform-docs \
        && mv terraform-docs /usr/local/bin

# Go
RUN curl -fsS https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz -o /tmp/downloads/golang.tar.gz \
        && tar -C /usr/local -xvf /tmp/downloads/golang.tar.gz

# gotestsum
RUN curl -fsSL https://github.com/gotestyourself/gotestsum/releases/download/v${GOTESTSUM_VERSION}/gotestsum_${GOTESTSUM_VERSION}_linux_amd64.tar.gz -o /tmp/downloads/gotestsum.tar.gz \
        && tar -C /tmp/downloads -xzf /tmp/downloads/gotestsum.tar.gz \
        && mv /tmp/downloads/gotestsum /usr/bin

# golangci-lint
RUN curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b /usr/bin v${GOLANGCILINT_VERSION}

# Install k3d
RUN curl -s https://raw.githubusercontent.com/rancher/k3d/main/install.sh | bash

# Install kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl \
        && chmod +x ./kubectl \
        && mv ./kubectl /usr/local/bin

# Install Telepresence
RUN curl -s https://packagecloud.io/install/repositories/datawireio/telepresence/script.deb.sh | bash
RUN apt install -y --no-install-recommends telepresence

# Install task
RUN curl -s https://taskfile.dev/install.sh | bash

# Cleanup
RUN rm -rf /tmp/downloads

# Golang environmentals and path
ENV GO111MODULE=on
ENV CGO_ENABLED=0
ENV PATH=$PATH:/usr/local/go/bin

# Setting the ENTRYPOINT to docker-init.sh will configure non-root access to
# the Docker socket if "overrideCommand": false is set in devcontainer.json.
# The script will also execute CMD if you need to alter startup behaviors.
ENTRYPOINT [ "/usr/local/share/docker-init.sh" ]
CMD [ "sleep", "infinity" ]

# #  [Optional] Use go get to install anything else you need
# ENV GOPATH /home/vscode/go
# RUN go get \
#         github.com/uudashr/gopkgs/v2/cmd/gopkgs \
#         github.com/ramya-rao-a/go-outline \
#         github.com/go-delve/delve/cmd/dlv \
#         github.com/go-delve/delve/cmd/dlv@f95340ae1bf9 \
#         honnef.co/go/tools/cmd/staticcheck \
#         golang.org/x/tools/gopls

# [Optional] Uncomment this section to install additional OS packages.
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends iptables
