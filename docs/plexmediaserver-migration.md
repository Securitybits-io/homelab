# Plex Media Server Migration Runbook

This runbook covers moving an existing Plex Media Server VM to a new VM built from the Debian 13 Proxmox template. The goal is to rebuild the OS while preserving Plex metadata, posters, watched state, collections, playlists, server settings, and library state.

The new VM should be created first with Terraform, then configured manually with Ansible after it is reachable. Plex application data is migrated separately from the VM OS disk.

## What Must Be Preserved

Plex's important state lives in the Plex Media Server data directory, not in the base OS image.

On Debian and Ubuntu package installs, the default data directory is:

```text
/var/lib/plexmediaserver/Library/Application Support/Plex Media Server/
```

This directory contains the Plex database, preferences, metadata, posters, artwork, plug-in support files, view state, watched state, collections, playlists, and server identity information.

Media files are separate. They must either remain on the same mounted storage paths or be migrated carefully.

## Preferred Migration Shape

```text
Old Plex VM
  -> stop Plex
  -> archive Plex data directory
  -> copy archive to backup storage
  -> create new Debian 13 VM from Terraform template
  -> mount media paths
  -> install Plex
  -> stop Plex
  -> restore Plex data directory
  -> fix ownership
  -> start Plex
  -> verify
```

## Pre-Migration Checklist

1. Confirm the old Plex VM is healthy enough to make a consistent backup.
2. Confirm where Plex data lives on the old VM.
3. Confirm where media is mounted on the old VM.
4. Decide whether the new VM will use the same media paths.
5. Disable Plex's automatic trash emptying before any migration work.
6. Make sure the new Debian 13 VM can mount the same media storage.
7. Make sure you have enough temporary space for the Plex metadata archive.

## Disable Automatic Trash Emptying

In the Plex web UI, disable:

```text
Settings -> Library -> Empty trash automatically after every scan
```

Keep this disabled until the new server has been verified. This prevents Plex from deleting library entries if media paths are temporarily unavailable during migration.

## Inspect The Old Server

Run these on the old Plex VM:

```bash
sudo systemctl status plexmediaserver --no-pager
sudo ls -lah "/var/lib/plexmediaserver/Library/Application Support/Plex Media Server"
findmnt
```

Capture the current library mount paths. Examples:

```text
/mnt/media/Movies
/mnt/media/TV
/mnt/media/Music
```

The easiest migration is to mount media at the exact same paths on the new VM.

## Stop Plex On The Old VM

Stop Plex before taking the backup so the database is consistent:

```bash
sudo systemctl stop plexmediaserver
sudo systemctl is-active plexmediaserver
```

The second command should return:

```text
inactive
```

## Back Up Plex Data

Create a compressed archive outside the Plex data directory:

```bash
sudo tar --xattrs --acls -czpf /tmp/plexmediaserver-data.tar.gz \
  --exclude="Plex Media Server/Cache" \
  --exclude="Plex Media Server/Logs" \
  -C "/var/lib/plexmediaserver/Library/Application Support" \
  "Plex Media Server"
```

The `Cache` and `Logs` directories are excluded to reduce backup size. Keep them if you want a fully literal copy, but they are not usually needed for migration.

Verify the archive:

```bash
sudo tar -tzf /tmp/plexmediaserver-data.tar.gz | head
sudo ls -lh /tmp/plexmediaserver-data.tar.gz
```

Copy the archive to backup storage or directly to the new VM:

```bash
rsync -avh /tmp/plexmediaserver-data.tar.gz user@backup-host:/path/to/backups/
```

or:

```bash
rsync -avh /tmp/plexmediaserver-data.tar.gz user@new-plex-vm:/tmp/
```

After the backup has been copied and verified, Plex can be started again on the old VM if you need to keep service running until the final cutover:

```bash
sudo systemctl start plexmediaserver
```

For the final cutover, stop Plex again and make a fresh final archive.

## Build The New VM

Create the replacement VM from the Debian 13 Terraform template.

The template cloud-init should make the VM reachable with SSH and ready for manual Ansible configuration. Ansible can then install baseline packages, mount storage, configure firewall rules, and install Plex.

Do not open the Plex setup wizard before restoring the old data.

## Prepare The New VM

Install Plex Media Server on the new VM. Then stop it before restoring data:

```bash
sudo systemctl stop plexmediaserver
```

Confirm the Plex user exists:

```bash
id plex
```

Make sure the parent directory exists:

```bash
sudo mkdir -p "/var/lib/plexmediaserver/Library/Application Support"
```

## Mount Media On The New VM

Prefer the same media mount paths as the old VM. For example, if the old server used:

```text
/mnt/media/Movies
/mnt/media/TV
```

then configure the new server to use the same paths before Plex starts.

If media paths change, use Plex's path migration workflow instead of immediately deleting old paths:

1. Restore and start Plex with automatic trash emptying still disabled.
2. Edit each library and add the new media path.
3. Scan the library and let Plex match files to existing entries.
4. Verify metadata, posters, collections, and watched state.
5. Remove the old path from the library only after verification.

## Restore Plex Data On The New VM

Copy the backup archive to the new VM if it is not already there:

```bash
rsync -avh user@backup-host:/path/to/backups/plexmediaserver-data.tar.gz /tmp/
```

Stop Plex:

```bash
sudo systemctl stop plexmediaserver
```

Move aside any newly-created Plex data directory:

```bash
sudo mv \
  "/var/lib/plexmediaserver/Library/Application Support/Plex Media Server" \
  "/var/lib/plexmediaserver/Library/Application Support/Plex Media Server.new-install.$(date +%Y%m%d%H%M%S)" \
  2>/dev/null || true
```

Restore the archive:

```bash
sudo tar --xattrs --acls -xzpf /tmp/plexmediaserver-data.tar.gz \
  -C "/var/lib/plexmediaserver/Library/Application Support"
```

Fix ownership:

```bash
sudo chown -R plex:plex "/var/lib/plexmediaserver/Library/Application Support/Plex Media Server"
```

Start Plex:

```bash
sudo systemctl start plexmediaserver
sudo systemctl status plexmediaserver --no-pager
```

## Verify The Migration

In the Plex web UI, verify:

1. The server appears as the expected migrated server.
2. Libraries are present.
3. Posters and metadata are present.
4. Watched state is present.
5. Collections and playlists are present.
6. Media paths are available.
7. New playback works.
8. Remote access and local network access behave as expected.

Check logs if Plex does not start cleanly:

```bash
sudo journalctl -u plexmediaserver -n 200 --no-pager
sudo ls -lah "/var/lib/plexmediaserver/Library/Application Support/Plex Media Server/Logs"
```

## After Verification

Only after the new server is confirmed working:

1. Re-enable automatic trash emptying if desired.
2. Update DNS or DHCP reservations if the hostname/IP changed.
3. Update firewall rules if needed.
4. Update monitoring checks.
5. Keep the old VM powered off but available until you are comfortable with the migration.
6. Keep the backup archive until the new VM has survived at least one normal maintenance cycle.

## Rollback

If the migration fails:

1. Stop Plex on the new VM.
2. Power off the new VM or remove it from DNS.
3. Start Plex on the old VM.
4. Re-check media mounts on the old VM.
5. Keep automatic trash emptying disabled until the old server is confirmed healthy.

## Long-Term Recommendation

For future Debian template rebuilds, keep Plex application data and media separate from the VM OS disk.

Good target layout:

```text
OS disk:
  Debian 13 VM from Terraform template

Persistent application data:
  /var/lib/plexmediaserver

Persistent media storage:
  /mnt/media
```

That allows the VM to be rebuilt while Plex data and media remain on persistent storage.

## References

- [Plex: Backing Up Plex Media Server Data](https://support.plex.tv/articles/201539237-backing-up-plex-media-server-data/)
- [Plex: Where is the Plex Media Server data directory located?](https://support.plex.tv/articles/202915258-where-is-the-plex-media-server-data-directory-located/)
- [Plex: Move an Install to Another System](https://support.plex.tv/articles/201370363-move-an-install-to-another-system/)
- [Plex: Restore a Database Backed Up via Scheduled Tasks](https://support.plex.tv/articles/202485658-restore-a-database-backed-up-via-scheduled-tasks/)
