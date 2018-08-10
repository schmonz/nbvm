# TODO: Amitai's Package Automation

## Try to upload incrementally

- Extract `pkgsrc-target-binary-upload`, an `rsync` wrapper
- As soon as the build has created a new package, background the wrapper
- When it returns (whether success or failure), `sleep 300` and go again
- When the build has completed, kill the kid and rerun in foreground
