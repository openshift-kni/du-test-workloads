## Kube-burner based template for a RAN DU workload

Templates for a DU workload deployed with [kube-burner](https://github.com/kube-burner/kube-burner)

| Pod | Number of Pods | Specs | Stress |
|-----|----------------|-------| ------- |
| Guaranteed | 1 pod, 2 containers | - 32 CPU, 1 GiB Memory, 16 GiB HP<br>- 2 configmaps and 4 secrets<br> 1 svc<br> | 32 threads of 100% CPU stress, 512M virtual memory stress |
| BestEffort - web_server | 4 pods, 2 containers each | - 100 mc CPU, 128 Mib Memory<br>- 2 configmaps and 4 secrets<br> | Exposes 8080 port for probes |
| BestEffort - curl_app | 4 pods, 2 containers each | - 100 mc CPU, 128 Mib Memory<br>- 2 configmaps and 4 secrets<br>- Liveness Probes (every 10 secs)| Kubelet stress with probes, ~250 KB per sec n/w traffic on Primary CNI |
| BestEffort - kubectl_pods | 6 pods, 2 containers each | - 100 mc CPU , 128 Mib Memory<br>- 2 configmaps and 4 secrets<br>- 2 kubectl gets (every 5 sec) | Kube-api-server stress with kubectl get, ~10% increase due to workload |

* Total pods - 15 pods / 30 containers
* 2 config maps and 4 secrets in each pod
* Exec Probes less than 10 in total and frequency >10 secs
* No Exec probes on Gu pod
* Traffic on primary CNI due to workload expected around 350 KB per sec
* kube api-server incremental load due to workload expected to increase by 5-8%

###### Intended for use in internal system testing pipelines but the templates can be run on any cluster with kube-burner

### Steps to run workload with cpu_utilization tests

* Run the MIRROR_SPOKE_OPERATOR_IMAGES stage in ocp-far-edge-vran-deployment pipeline to mirror necessary test images
* Run the cpu_util test using ocp-far-edge-vran-tests pipeline

### Steps to run locally

* clone this repo
* run the following

    ```shell
    export REGISTRY="" # For a connected cluster
    export NODE_NAME=$( oc get nodes -ojson | jq .items[0].metadata.name -r) # For SNO
    export KUBECONFIG="..."
    kube-burner init --config du-intensive.yaml
    ```
