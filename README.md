# charts

tbc

## Use chart

Add the repo and install. Note some of the charts do expect a minimum amount of config, see testconfigs

```commandline
helm repo add tokheim https://tokheim.github.io/charts/
helm repo update
helm upgrade --install test tokheim/stdapp --debug --dry-run
```
