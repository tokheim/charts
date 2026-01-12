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
        echo "testing chart $chart w/ cfg $configpath in ns $ns"
        helm upgrade --install test-app -n $ns helm/$chart -f $configpath --debug --dry-run=server
        helm upgrade --install test-app -n $ns helm/$chart -f $configpath $args
        echo "running tests for chart $chart w/ cfg $configpath"
        helm test test-app -n $ns --timeout 60s --logs
    done
done
