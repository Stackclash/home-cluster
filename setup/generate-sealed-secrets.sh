#!/usr/bin/env bash

__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${__dir}/environment.sh"

# Create secrets file
truncate -s 0 "${GENERATED_SECRETS}"

txt=$(find "${CLUSTER_ROOT}" -type f -name "*.txt")

if [[ ( -n $txt ) ]];
then
    printf "%s\n%s\n%s\n" "#" "# Auto-generated helm secrets -- DO NOT EDIT." "#" >> "${GENERATED_SECRETS}"

    # Helm Secrets
    for file in "${CLUSTER_ROOT}"/**/*.txt; do
        # Get the path and basename of the txt file
        # e.g. "deployments/default/pihole/pihole"
        secret_path="$(dirname "$file")/$(basename -s .txt "$file")"
        # Get the filename without extension
        # e.g. "pihole"
        secret_name=$(basename "${secret_path}")
        # Get the relative path of deployment
        deployment=${file#"${CLUSTER_ROOT}"}
        # Get the namespace (based on folder path of manifest)
        namespace=$(echo "${deployment}" | awk -F/ '{print $2}')
        # Get contents of file after variable substitution
        contents=$(envsubst < "$file")

        if [[ "${file}" =~ "values" ]]
        then
            echo "[*] Generating helm secret '${secret_name}' in namespace '${namespace}'..."
            secret_json=$(kubectl -n "${namespace}" create secret generic "${secret_name}" --from-literal=values.yaml="$contents" --dry-run=client -o json)
        else
            echo "[*] Generating generic secret '${secret_name}' in namespace '${namespace}'..."
            secret_json=$(kubectl -n "${namespace}" create secret generic "${secret_name}" --from-literal="$contents" --dry-run=client -o json)
        fi

        echo "${secret_json}" |
            kubeseal --format=yaml --cert="${PUB_CERT}" |
            # Remove null keys
            yq eval 'del(.metadata.creationTimestamp)' - |
            yq eval 'del(.spec.template.metadata.creationTimestamp)' - |
            # Format yaml file
            gsed -e '1s/^/---\n/' |
            # Write secret
            tee -a "${GENERATED_SECRETS}" >/dev/null 2>&1
    done
fi

# Validate Yaml
if ! yq eval "${GENERATED_SECRETS}" >/dev/null 2>&1; then
    echo "Errors in YAML"
    exit 1
fi

exit 0
