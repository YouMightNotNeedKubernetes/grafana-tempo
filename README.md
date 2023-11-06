# Grafana Tempo
A high-availability Grafana Tempo deployment for Docker Swarm

## Getting Started

You might need to create swarm-scoped overlay network called `dockerswarm_monitoring` for all the stacks to communicate if you haven't already.

```sh
$ docker network create --scope=swarm --driver overlay --attachable dockerswarm_monitoring
```

We provided a base configuration file for Grafana Tempo. You can find it in the `config` folder.  
Please make a copy as `configs/tempo.yml`, make sure to change the following values:

```yml
storage:
  trace:
    backend: s3
    s3:
      # !!! IMPORTANT !!!
      # ! Update this to the IP address of your MinIO server
      bucket: tempo
      endpoint: host.docker.internal:9000
      access_key: minioadmin
      secret_key: minioadmin
      insecure: true
    wal:
      path: /tempo-data/wal             # where to store the the wal locally
    local:
      path: /tempo-data/blocks

distributor:
  # ...
  ring: &x-ring-config
    kvstore: &x-kvstore-config
      store: consul
      prefix: tempo/
      consul:
        # !!! IMPORTANT !!!
        # ! Update this to the IP address of your Consul server
        host: host.docker.internal:8500
        # acl_token: secret

metrics_generator:
  # ...
  registry:
    external_labels:
      source: tempo
      cluster: demo
  storage:
    # ...
    remote_write:
      - url: http://prometheus:9090/api/v1/write
        send_exemplars: true
```

And add any additional configuration you need to `configs/tempo.yml`.

### Object Storage buckets

You need to create the following buckets in your object storage:
- `tempo`

You can change the bucket names in the `configs/tempo.yml` file. Look for the `bucket` property.

## Deployment

To deploy the stack, run the following command:

```sh
$ make deploy
```

## Destroy

To destroy the stack, run the following command:

```sh
$ make destroy
```
