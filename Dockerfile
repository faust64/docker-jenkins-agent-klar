FROM golang:1.13-alpine AS builder

RUN set -x \
    && apk --update add git \
    && go get -d github.com/optiopay/klar \
    && go build ./src/github.com/optiopay/klar

FROM openshift/jenkins-slave-base-centos7

LABEL com.redhat.component="jenkins-agent-klar" \
      io.k8s.description="The jenkins agent klar image has the tools scanning Docker images against CoreOS Clair." \
      io.k8s.display-name="Jenkins Agent - Klar" \
      io.openshift.tags="openshift,jenkins,agent,clair,klar" \
      architecture="x86_64" \
      name="ci/jenkins-agent-klar" \
      maintainer="Samuel MARTIN MORO <faust64@gmail.com>" \
      help="For more information visit https://github.com/faust64/docker-jenkins-agent-klar" \
      version="1.0"

COPY --from=builder /go/klar /usr/local/bin/klar

RUN if yum -y install epel-release; then \
	if test "$DO_UPGRADE"; then \
	    yum -y upgrade; \
	fi \
	&& yum -y install ca-certificates jq; \
    else \
	curl https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 -o /usr/bin/jq \
	&& chmod +x /usr/bin/jq; \
    fi

USER 1001
