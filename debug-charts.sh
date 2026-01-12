#!/usr/bin/env bash
set -e

args="--create-namespace --wait --timeout 60s --debug"

for path in helm/*/ ; do
    chart=$(basename "$path");
    echo "Testing $chart";
    for configpath in testconfigs/$chart/*.yaml ; do
        filename=$(basename -- "$configpath")
        config="${filename%.*}"
        ns="$chart-${config%.*}"
        echo "status chart $chart w/ cfg $configpath in ns $ns"
        helm status test-app -n $ns
    done
done
