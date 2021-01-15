# Retaining Persistent Disks


## Retaining Disks

The GKE Clusters for QServ are provisioned with [CSI Driver](https://cloud.google.com/kubernetes-engine/docs/how-to/persistent-volumes/gce-pd-csi-driver) as an add on.  This allows persistent disks to be retained and reattached to new or existing GKE clusters.  To keep the disks the reclaim policy needs to be set to `Retain` on each storage class. This [link](https://cloud.google.com/kubernetes-engine/docs/how-to/persistent-volumes/preexisting-pd) discussed how to reattach an existing persistent volume.

QServ will retain disks and reattach to reduce the amount of time data needs to be loaded.  To perform this the QServ deployment scripts were updated to create two new storage classes with the GCP CSI driver.  Below are the abbreviated details for each storage class. Both are set for a volume binding mode of `WaitForFirstConsumer` because that is what the driver requires.

### QServ czar Storage Class

```
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  annotations:
  name: czar
parameters:
  type: pd-ssd
provisioner: pd.csi.storage.gke.io
reclaimPolicy: Retain
volumeBindingMode: WaitForFirstConsumer
```

The storage class and volume name is then configured on the PVC to attach the existing volume. Example below.

```
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  annotations:
    volume.beta.kubernetes.io/storage-provisioner: pd.csi.storage.gke.io
  labels:
    app: qserv
    app.kubernetes.io/managed-by: qserv-operator
    component: czar
    instance: qserv
  name: qserv-data-qserv-czar-0
  namespace: default
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 500Gi
  storageClassName: czar
  volumeMode: Filesystem
  volumeName: pvc-03fd0e21-8408-4e50-9144-fc7f0128101d
```

### QServ Worker Storage Class

```
allowVolumeExpansion: true
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  annotations:
  name: qserv
parameters:
  type: pd-balanced
provisioner: pd.csi.storage.gke.io
reclaimPolicy: Retain
volumeBindingMode: WaitForFirstConsumer
```
The storage class and volume name is then configured on the PVC to attach the existing volume. Example below.

```
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  annotations:
    volume.beta.kubernetes.io/storage-provisioner: pd.csi.storage.gke.io
  labels:
    app: qserv
    app.kubernetes.io/managed-by: qserv-operator
    component: worker
    instance: qserv
  name: qserv-data-qserv-worker-0
  namespace: default
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 500Gi
  storageClassName: qserv
  volumeMode: Filesystem
  volumeName: pvc-671e3ff8-aff8-46f9-a04f-8c4f0da2df97
```


## Disk Cleanup

Please note that persistent volume claims (PVC) are not automatically deleted when a GKE cluster is deleted.  Issue described[here](https://issuetracker.google.com/issues/121034250).  If PVCs should be removed delete from Kubernetes before cluster deletion or delete disks from gcp console under Compute > Disks