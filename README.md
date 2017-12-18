
## About
---
GitGuard is designed to help GitCloud to manage the Git server. It has a series of RESTFUL APIs base on LibGit2, and a raft system to makesure there are two other copies on the other Git server.

## Installation
---

install [libgit2(0.17.0)](https://github.com/libgit2/libgit2/tree/v0.17.0)

```bash
cd npl_packages/main && git pull ## install the latest npl main packages
./start.sh ## start the server
```