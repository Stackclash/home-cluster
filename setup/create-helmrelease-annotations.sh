#!/usr/bin/env bash
shopt -s globstar
__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${__dir}/environment.sh"

need gsed

for helm_release in "${CLUSTER_ROOT}"/**/*.yml; do
    # ignore flux-system namespace
    # ignore wrong apiVersion
    # ignore non HelmReleases
    if [[ "${helm_release}" =~ "flux-system"
        || $(yq eval '.apiVersion' "${helm_release}") != "helm.toolkit.fluxcd.io/v2beta1"
        || $(yq eval '.kind' "${helm_release}") != "HelmRelease" ]]; then
        continue
    fi

    for helm_repository in "${HELM_REPOSITORIES}"/*.yml; do
        chart_name=$(yq eval '.metadata.name' "${helm_repository}")
        chart_url=$(yq eval '.spec.url' "${helm_repository}")

        # only helmreleases where helm_release is related to chart_url
        if [[ $(yq eval '.spec.chart.spec.sourceRef.name' "${helm_release}") == "${chart_name}" ]]; then
            # delete "renovate: registryUrl=" line
            # Need GNU version of sed
            gsed -i "/renovate: registryUrl=/d" "${helm_release}"
            # insert "renovate: registryUrl=" line
            gsed -i "/.*chart: .*/i \ \ \ \ \ \ # renovate: registryUrl=${chart_url}" "${helm_release}"
            echo "Annotated $(basename "${helm_release%.*}") with ${chart_name} for renovatebot..."
            break
        fi
    done
done
