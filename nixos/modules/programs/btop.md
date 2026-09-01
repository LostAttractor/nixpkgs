# btop {#module-programs-btop}

[`btop`](https://github.com/aristocratos/btop) is a resource monitor that shows
usage and statistics for processors, memory, disks, networks, processes, and
supported GPUs.

The package cannot carry Linux file capabilities in the Nix store. This module
therefore creates a wrapper with `CAP_PERFMON` and `CAP_DAC_READ_SEARCH`, which
are the capabilities installed by btop's upstream `make setcap` target. They
allow btop to collect process and GPU statistics that are otherwise unavailable
to unprivileged users.

To install btop and enable the capability wrapper:

```nix
{ programs.btop.enable = true; }
```
