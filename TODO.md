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

## Try to upload incrementally

- Extract `pkgsrc-target-binary-upload`, an `rsync` wrapper
- As soon as the build has created a new package, background the wrapper
- When it returns (whether success or failure), `sleep 300` and go again
- When the build has completed, kill the kid and rerun in foreground
