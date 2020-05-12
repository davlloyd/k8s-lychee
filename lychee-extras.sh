

#wavefront
kubectl create namespace wavefront
helm install wavefront wavefront/wavefront --set wavefront.url=https://longboard.wavefront.com --set wavefront.token=7fb151a3-778f-416b-842f-894cedd583ff --set clusterName=lycheedell --namespace wavefront


#kubdb
curl -fsSL https://github.com/kubedb/installer/raw/v0.13.0-rc.0/deploy/kubedb.sh | bash
# use the script local in the repo as it has the updated SSL driver V14

#kubedb with monitoring
kubectl create ns monitoring
curl -fsSL https://github.com/kubedb/installer/raw/v0.13.0-rc.0/deploy/kubedb.sh | bash -s -- \
  --monitoring-enable=true \
  --monitoring-agent=prometheus.io/coreos-operator \
  --prometheus-namespace=monitoring \
  --servicemonitor-label=k8s-app=prometheus

