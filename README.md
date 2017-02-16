# home-network-configs

Configuration backups of our home network, spans 3 miles, provides Internet access to 6 families in West Wales.

Using [Oxidized](https://github.com/ytti/oxidized), running in [Docker](https://github.com/ytti/oxidized/blob/master/Dockerfile). Config changes are pushed to this repo and also notifications are posted to our home [Slack](http://slack.com) instance.

## Oxidized setup

`/etc/oxidized/prod/` is mapped to `/root/.config/oxidized/` in the container.

The `/etc/oxidized/prod` directory contains:

```
-rw-r--r-- 1 root root 1053 Feb 16 10:57 config
drwxr-xr-x 2 root root 4096 Feb 16 10:57 logs
-rw-r--r-- 1 root root    1 Feb 16 10:57 pid
drwxr-xr-x 3 root root 4096 Feb 16 10:56 repo
-rw-r--r-- 1 root root  189 Feb 16 10:54 router.db
-rw------- 1 root root 1679 Feb 16 10:54 ssh-netcfg-prod
-rw-r--r-- 1 root root  407 Feb 16 10:55 ssh-netcfg-prod.pub
```

Keys generated with `ssh-keygen -b 2048 -t rsa ssh-netcfg-prod`, then the public half uploaded to our [oxidized-pembs](https://github.com/oxidized-pembs) github account.

Repo was cloned using `ssh-agent bash -c 'ssh-add ssh-netcfg-test; git clone git@github.com:natm/home-network-configs-test.git repo'`.

router.db:

```
homewlc1.gorras.hw.esgob.com:aireos
rt0.gorras.hw.esgob.com:edgeos
rt1.gorras.hw.esgob.com:edgeos
rt2.gorras.hw.esgob.com:edgeos
sw1.gorras.hw.esgob.com:ios
rt0.cowshed.hw.esgob.com:edgeos
```

config:

```
---
username: oxidized-prod
password: ###############
interval: 3600
use_syslog: false
debug: false
threads: 30
timeout: 20
retries: 3
prompt: !ruby/regexp /^([\w.@-]+[#>]\s?)$/
rest: 127.0.0.1:8888
vars: {}
groups: {}
pid: "/root/.config/oxidized/pid"
input:
  default: ssh, telnet
  debug: false
  ssh:
    secure: false
output:
  default: git
  git:
    user: "oxidized-pembs"
    email: oxidized@esgob.com
    repo: "/root/.config/oxidized/repo"
source:
  default: csv
  csv:
    file: "/root/.config/oxidized/router.db"
    delimiter: !ruby/regexp /:/
    map:
      name: 0
      model: 1
model_map:
  cisco: ios
  juniper: junos
hooks:
  slack:
    type: slackdiff
    events: [post_store]
    token: ###############
    channel: "#oxidized-prod"
  push_to_remote:
    type: githubrepo
    events: [post_store]
    remote_repo: git@github.com:natm/home-network-configs.git
    publickey: "/root/.config/oxidized/ssh-netcfg-prod.pub"
    privatekey: "/root/.config/oxidized/ssh-netcfg-prod"
vars:
  remove_secret: true
```

## Questions?

Contact me!
