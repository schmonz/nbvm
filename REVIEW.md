# nbvm Codebase Improvement Plan

## Context

nbvm is a ~400-line shell-script toolkit for managing headless QEMU guest VMs across
diverse Unix OSes and architectures. It covers NetBSD/SPARC/HPPA/PowerPC/VAX — territory
that rules out most industry-standard VM managers (Lima, libvirt, Vagrant) which are
Linux/x86-centric or daemon-dependent. The pure-shell approach is justified.

That said, several custom subsystems reinvent well-established tools, and the project has
no automated testing or linting at all. The improvements below are ordered roughly by
impact.

---

## 1. Replace Missing Test Infrastructure with BATS

**Current state:** Zero automated tests. Regressions are caught only by manual use.

**Industry standard:** [bats-core](https://github.com/bats-core/bats-core) is the
de-facto test framework for shell scripts. Pure Bash, no external runtime dependencies,
produces TAP output, works on all platforms the project targets.

**What to test immediately:**

- `nb ls` output format (each line: `opsys version arch`)
- `nb_qemu_accel` returns one of the known accelerator names
- `_nb_complete` with 1, 2, and 3 arguments
- `nbvm isvm` exit codes (0 in VM, non-zero outside)
- `nbvm ncpus` returns a positive integer
- `qemu-fqdn2mac` output matches `02:xx:xx:xx:xx:xx` pattern
- `qemu-port-allocate` returns a number not already in any config file

**File to create:** `test/` directory with `*.bats` files.
**Install BATS** as a git submodule: `git submodule add https://github.com/bats-core/bats-core test/bats`
Add `make test` target to Makefile.

---

## 2. Add ShellCheck as CI Lint Gate

**Current state:** No linting. Several portability bugs have silently survived.

**Industry standard:** [ShellCheck](https://www.shellcheck.net/) is the universal
shell-script linter. It catches exactly the bugs listed in section 4 below.

**Add `.github/workflows/ci.yml`:**
```yaml
on: [push, pull_request]
jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: shellcheck bin/nb bin/nbvm bin/qemu-disk-create bin/qemu-disk-import
               bin/qemu-fqdn2mac bin/qemu-port-allocate
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with: { submodules: true }
      - run: make test
```

ShellCheck would have caught all bugs in section 4 before they landed.

---

## 3. Replace Custom SSH Invocation with SSH Config Management

**Current state:** Every SSH call is `ssh -p ${QEMU_PORT} localhost`. Users can't use
standard tools (`scp`, `rsync`, IDE remote extensions) without knowing port numbers.

**Industry standard:** `~/.ssh/config` Host entries — the standard way Unix users manage
multi-host SSH.

**Add a new subcommand `nb sshconfig`** (or make `nb sshid` also write config):
```
Host nbvm-debian12-amd64
    HostName localhost
    Port 7780
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null
```

This would let users do `ssh nbvm-debian12-amd64`, `scp file nbvm-debian12-amd64:/tmp/`,
`rsync -av . nbvm-ubuntu24-amd64:~/project/` — all standard Unix workflows — without
changes to `nb` itself.

**File to modify:** `bin/nb` — add `nb_sshconfig` function and register it in `main()`.

---

## 4. Replace Config Sourcing with a Safer Format

**Current state:** `nb_qemu_read_guest_config` does `. "${config}"` — sourcing a shell
script. This executes arbitrary code. The executable-bit guard helps but doesn't prevent
a config file containing `$(rm -rf ~)` in a value.

**Industry standard:** Key=value `.env`-style files (no code, only assignments). Since
all QEMU_* values are simple strings, configs can be parsed without `source`:

```sh
# Parse key=value without executing (pure POSIX sh):
_nb_load_config() {
    while IFS='=' read -r key value; do
        case "${key}" in
            QEMU_ARCH|QEMU_DISK|QEMU_PORT|QEMU_CPUS|QEMU_RAMS|\
            QEMU_ENET|QEMU_MCNE|QEMU_BIOS|QEMU_EDRV|QEMU_DKIF|\
            QEMU_HCPU|QEMU_ARGS|QEMU_ACEL)
                eval "${key}='${value}'"
                ;;
        esac
    done < "${config}"
}
```

**Exception:** `etc/nbvm-netbsdcurrent-riscv64` is an executable shell script (has
custom kernel boot logic). It stays as-is and is already handled by the executable-bit
check. All other 26 configs are pure key=value today.

---

## 5. Fix Confirmed Bugs (ShellCheck Would Flag These)

### 5a. `==` bashism in `#!/bin/sh` (`bin/nb:80`)
```sh
# fix: = not ==
if [ "${canonicalized_guest_arch}" = "${arch}" ]; then
```

### 5b. `tail +2` non-POSIX (`bin/nb:38`)
```sh
available_accels="$(qemu-system-${qemu_arch} -accel help | tail -n +2)"
```

### 5c. `local` in POSIX sh (`bin/vbox-manage:13,58,59`, `bin/qemu-fqdn2mac:6`)
Replace `local _var` with `_var=` at function scope (follow existing `_`-prefix convention).

### 5d. Empty-list miscount in `_nb_complete` (`bin/nb:107-108`)
`echo "" | wc -l` returns 1. Guard before counting:
```sh
[ -z "${list}" ] && nb_usage
count=$(echo "${list}" | wc -l)
```

### 5e. Substring match bug in `qemu-port-allocate` (`bin/qemu-port-allocate:12`)
```sh
while echo "${allocated}" | grep -q "^${first_available}$"; do
```

### 5f. `qemu-fqdn2mac` uses `digest md5` (NetBSD/Solaris only, `bin/qemu-fqdn2mac:11`)
Add a portable wrapper:
```sh
_md5() { md5sum 2>/dev/null || md5 2>/dev/null || digest md5; }
```

---

## 6. Complete the XXX TODOs

### 6a. `_nb_complete` with 2 args (`bin/nb:102`)
```sh
if [ $# -eq 2 ]; then
    opsys="$1"; version="$2"
    list=$(_nb_opsys_all_known_arches "${opsys}" "${version}")
    count=$(echo "${list}" | wc -l)
    if [ "${count}" -eq 1 ]; then arch="${list}"
    else arch="$(_nb_qemu_host_arch)"; fi  # prefer host arch
    echo "opsys=${opsys}" "version=${version}" "arch=${arch}"
    return
fi
```

### 6b. Best-version selection when >1 match (`bin/nb:125-128`)
```sh
best=$(echo "${list}" | sort --version-sort | tail -1)
version=$(echo "${best}" | cut -d' ' -f2)
arch=$(echo "${best}" | cut -d' ' -f3)
echo "opsys=${opsys}" "version=${version}" "arch=${arch}"
return
```

### 6c. `nbvm_shutdown` — handle unknown OS (`bin/nbvm:125-146`)
```sh
*)  warn "$(uname): don't know how to shut down"; exit 1 ;;
```

---

## 7. Clean Up Dead Code

- **`bin/vbox-manage`**: Strip the 6 `SCHMONZ` debug `echo >&2` lines (or rename to
  `unused-vbox-manage` to reflect its status).
- **`bin/unused-netbsdify-external-compiler`**: Has hardcoded `/home/schmonz/` paths.
  Delete or generalize.
- **`bin/unused-tmux-all-panes`**: Purpose unclear. Add a comment or delete.

---

## 8. Minor Consistency

- **Arch naming in `etc/`**: Three names for x86-64 (`x86_64`, `amd64`, `x64`). Pick
  one. Most configs use `amd64`; rename `nbvm-alpine3-x86_64` and `nbvm-tribblix37-x64`.
- **Memory format**: Mix of bare MB (`1536`) and `g` suffix (`1g`, `2g`). Pick one per
  config and add a note in a template/README.

---

## Verification

1. `shellcheck bin/nb bin/nbvm bin/qemu-*` → zero warnings
2. `make test` → all BATS tests pass
3. `nb boot ubuntu` (one arg) resolves to `ubuntu 24 amd64` (or highest version)
4. `nb boot ubuntu 20` (two args) resolves to `ubuntu 20 amd64`
5. `nb sshconfig` (or equivalent) writes valid `~/.ssh/config` entries
6. Push to GitHub → Actions workflow passes lint + test jobs

## Critical Files

- `bin/nb` — lines 38, 80, 97–129, 133
- `bin/nbvm` — lines 125–146
- `bin/qemu-port-allocate` — line 12
- `bin/qemu-fqdn2mac` — line 11
- `bin/vbox-manage` — debug lines 16–21, 43–46
- `etc/nbvm-*` — all 26 non-executable configs (for safer parsing + arch rename)
- `.github/workflows/ci.yml` — new file
- `test/*.bats` — new files
- `Makefile` — add `test` target
