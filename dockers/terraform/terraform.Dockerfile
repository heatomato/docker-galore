FROM alpine

RUN wget -O terraform.zip https://releases.hashicorp.com/terraform/0.12.24/terraform_0.12.24_linux_amd64.zip && \
    unzip terraform.zip && \
    mv terraform /usr/local/bin/terraform && \
    rm terraform.zip

USER nobody

ENTRYPOINT ["/usr/local/bin/terraform"]
CMD ["--help", "--version"]