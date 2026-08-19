# Secrets Handling

This repository contains infrastructure definitions and operational glue that can reference sensitive values. Treat secret handling as an explicit procedure, not a cleanup afterthought.

## Sensitive File Types

Treat these as sensitive unless verified otherwise:

- `ansible/vault.yml`
- `ansible/host_vars/**/vault`
- `ansible/host_vars/nomad/jobs-vars/*.nv.hcl`
- `jobs/**/env.nv.hcl`
- Application config files that contain API keys, tokens, passwords, or real user data

## Current Deployment Flow

`ansible/nomad.yml` finds files in:

```text
ansible/host_vars/nomad/jobs-vars/*.nv.hcl
```

It copies them to the Nomad server and applies them with:

```bash
nomad var put -force @/opt/jobs-vars/<file>
```

This makes the jobs-vars directory a practical integration point for generated Nomad variables from Bitwarden, Ansible Vault, or another secret source.

## Before Making the Repository Public

1. Search for direct private repository references.
2. Search for plaintext tokens, passwords, API keys, and realistic example credentials.
3. Replace realistic examples with unmistakable placeholders.
4. Remove or encrypt tracked secret payloads.
5. Rotate any credential that was ever committed in plaintext.
6. Confirm `.gitignore` prevents generated plaintext secret files from being added again.
7. Re-run the scan after cleanup.

Useful local scans:

```bash
rg -n "password|passwd|secret|token|api[_-]?key|client[_-]?secret|PRIVATE|BEGIN .*KEY" .
rg -n "homelab-secrets|/opt/homelab-secrets|\.nv\.hcl" ansible jobs
git status --short
```

Search results are only indicators. Always inspect the surrounding file context before deciding whether a value is sensitive.

## Nomad Variable Procedure

When adding a new job that needs secrets:

1. Put non-sensitive defaults in the job spec or app config.
2. Put sensitive values in a Nomad variable file generated from a secret source.
3. Keep the variable file out of Git unless it is encrypted.
4. Add the job's required variable path to this documentation or the job README.
5. Run the Ansible Nomad secrets tag to apply variables.
6. Run `nomad job plan` before submitting the job.

## Rotation Procedure

If a secret has been committed or exposed:

1. Revoke or rotate it at the source system.
2. Update the source of truth, such as Bitwarden or Ansible Vault.
3. Regenerate the Nomad variable file.
4. Apply it with `nomad var put -force`.
5. Restart or redeploy affected jobs.
6. Verify the old credential no longer works.
7. Record the rotation in private operational notes.

Do not rely on deleting a value from the latest commit as a rotation strategy.
