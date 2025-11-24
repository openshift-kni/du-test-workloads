ARG KUBE_BURNER_VERSION=v2.0.0
FROM quay.io/kube-burner/kube-burner:${KUBE_BURNER_VERSION}

RUN mkdir -p /home/kni/du-test-workloads

WORKDIR /home/kni/du-test-workloads

COPY ./* ./

CMD ["kube-burner", "init", "--config", "./du-intensive.yaml"]