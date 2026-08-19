# Nomad Operations

Nomad job specifications live under `jobs/` and are deployed by Ansible to the Nomad server.

## Job Layout

| Path | Purpose |
| --- | --- |
| `jobs/hashilab-apps/` | Application workloads such as media, tools, and user-facing services. |
| `jobs/hashilab-services/` | Shared services such as Traefik, Authelia, Grafana, Loki, Prometheus, and databases. |
| `jobs/hashilab-support/` | Maintenance, update, and storage support jobs. |
| `jobs/hashilab-dev/` | Development or experimental jobs. |

Active job specs use `.nomad` or `.nomad.hcl`. Files ending in `.bak` or `.dev` should be treated as inactive or work in progress unless deliberately submitted.

## Deploy Jobs and Variables

From the Ansible controller:

```bash
cd ansible
ansible-playbook -i production nomad.yml --ask-vault-pass --tags jobs,secrets
```

The playbook copies `jobs/` to `/opt/jobs` and pushes Nomad variable files from `ansible/host_vars/nomad/jobs-vars`.

## Validate a Job Locally

When the Nomad CLI is available:

```bash
nomad job validate path/to/job.nomad.hcl
nomad job plan path/to/job.nomad.hcl
nomad job run path/to/job.nomad.hcl
```

Run `plan` before `run` for existing jobs. Review allocations, destructive updates, service checks, volume changes, and constraint changes before applying.

## Submit a Job From the Server

```bash
ssh <nomad-server>
cd /opt/jobs
nomad job plan hashilab-services/traefik/traefik.nomad.hcl
nomad job run hashilab-services/traefik/traefik.nomad.hcl
```

## Troubleshoot a Failed Allocation

Start with placement before assuming an application or socket problem.

```bash
nomad job status <job>
nomad alloc status <allocation-id>
nomad alloc logs <allocation-id>
nomad alloc logs -stderr <allocation-id>
```

Check in this order:

1. The allocation landed on the expected node.
2. The node has required attributes, node class, meta values, or constraints.
3. The task user has access to required files, sockets, and volumes.
4. Host paths exist on the selected node.
5. Docker socket access is valid for jobs that need it.
6. Consul service registration and health checks are passing.

## Nomad HTTP API Fallback

When the local Nomad CLI is unavailable, use the API from a shell that can reach the Nomad server:

```bash
curl http://nomad:4646/v1/nodes
curl http://nomad:4646/v1/job/<job>/allocations
curl http://nomad:4646/v1/node/<node-id>
```

This is useful from Windows environments where the Nomad CLI is not installed.

## Docker Socket Checklist

For Docker-backed jobs that read `/var/run/docker.sock`:

1. Confirm the allocation is on the node you are inspecting.
2. Check socket ownership and mode on that node.
3. Check the Nomad task user and group.
4. Check Docker client configuration inside the task.
5. Read allocation stderr and Docker daemon logs.

Do not conclude that a socket permission change is needed before confirming placement.
