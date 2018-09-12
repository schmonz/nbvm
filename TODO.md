# TODO: Amitai's Package Automation

## Add Philolexian build bits

- Config files
- Scripts

## Refactor

- What's the same about `schmonz.com` and `philo.org` builds?
- What's different?
- One set of scripts
- One config that's shared across builds
- One config that's specific to each build

## Refactor to Vagrant

- Add Vagrant to pkgsrc
- Boot VM of a standard (and sufficiently like the target) OS image
- Install just enough tools to fetch pkgsrc and do builds
- Fetch latest pkgsrc (perhaps as `.tar.gz` from GitHub)
- Run `pbulk` directly (no `pkg_comp`)
- Upload packages
- Destroy VM

## Refactor to Terraform

- Add Terraform to pkgsrc
- Same idea as Vagrant, but on Vultr instead of my machine
- Then my machine and my uplink stop being bottlenecks
- Just need a machine running Terraform to pull the weekly trigger

## Run Terraform from `cron(8)` on the target!

- `schmonz.com` triggers its own weekly build
- `philo.org` triggers its own weekly build
