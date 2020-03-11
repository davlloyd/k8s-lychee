

#wavefront
kubectl create namespace wavefront
helm install wavefront wavefront/wavefront --set wavefront.url=https://longboard.wavefront.com --set wavefront.token=7fb151a3-778f-416b-842f-894cedd583ff --set clusterName=lychee1 --namespace wavefront


#kubdb
curl -fsSL https://github.com/kubedb/installer/raw/v0.13.0-rc.0/deploy/kubedb.sh | bash

