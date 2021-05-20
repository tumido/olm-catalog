CWD=$PWD

git clone https://github.com/pulp/pulp-operator /tmp/pulp-operator
pushd /tmp/pulp-operator

VERSION=`git rev-parse --short HEAD`

popd

# Update CSV reference
LAST_VERSION=`yq e ".channels[0].currentCSV" catalog/pulp-operator/pulp-operator.package.yaml`

if [ "$LAST_VERSION" == "pulp-operator-$VERSION.v0.0.0" ]; then
    echo "CSVs are already updated to $VERSION. Exiting."
    exit 1
fi

# Copy files over
mkdir -p catalog/pulp-operator/$VERSION
cp -r /tmp/pulp-operator/deploy/olm-catalog/pulp-operator/* catalog/pulp-operator/$VERSION/

yq -i e ".channels[0].currentCSV = \"pulp-operator-$VERSION.v0.0.0\"" catalog/pulp-operator/pulp-operator.package.yaml
yq -i e ".metadata.name = \"pulp-operator-$VERSION.v0.0.0\" | .spec.replaces = \"$LAST_VERSION\" | .spec.version = \"0.0.0\"" catalog/pulp-operator/$VERSION/manifests/pulp-operator.clusterserviceversion.yaml
