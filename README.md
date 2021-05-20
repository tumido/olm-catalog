# Custom dev catalog for OLM

## Pulp

To create new CSV from master of your repo and enlist that in the catalog run:

This script requires [golang based `yq`](https://mikefarah.gitbook.io/yq/) to be present on the system.

```sh
scripts/update_pulp.sh
```

Then rebuild the image and push it

## Catalog image

Please change the image tag in following commands to point to your own container image repository and ensure the repository is public:

```sh
podman build  -t quay.io/tcoufal/olm-catalog .
podman push quay.io/tcoufal/olm-catalog
```

## Deploy custom catalog

User must have access to `openshift-marketplace` namespace. Please change the image used by the catalog source (`.spec.image`) to point to your own repository.

```sh
oc apply -f  catalogsource.yaml
```

Then install operators via OLM.

## Updating operators and catalog

If you update the catalog image and you want to apply the updates immediately, simply delete the `custom-catalog` pod from `openshift-marketplace` namespace.

```sh
oc delete -n openshift-marketplace pod -l olm.catalogSource=custom-catalog
```
