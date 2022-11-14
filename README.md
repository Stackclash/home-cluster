<h1 align="center">
  My Home Kubernetes Cluster
  <br />
  <br />
  <img width="300" height="300" src="https://upload.wikimedia.org/wikipedia/commons/thumb/3/39/Kubernetes_logo_without_workmark.svg/1200px-Kubernetes_logo_without_workmark.svg.png">
</h1>
<br />
<div align="center">

[![Discord](https://img.shields.io/badge/discord-chat-7289DA.svg?maxAge=60&style=for-the-badge&logo=discord)](https://discord.gg/DNCynrJ) [![k3s](https://img.shields.io/badge/k3s-v1.25.3+k3s1-blue?style=for-the-badge&logo=kubernetes)](https://k3s.io/) [![GitHub last commit](https://img.shields.io/github/last-commit/rickcoxdev/home-cluster?logo=github&style=for-the-badge)](https://github.com/RickCoxDev/home-cluster/commits/main)

</div>

---

# :telescope:&nbsp; Overview
This repo is my home Kubernetes cluster declared using yaml files. My entire cluster is made up Raspberry Pi boards and thus all deployments here are made to work on ARM architecture. The Kubernetes flavor I use is [k3s](https://k3s.io) to keep the size to a minimum. I use [Flux](https://fluxcd.io) to watch this repo and deploy any changes I push here. Each folder represents a different namespace. Visit my [ansible playbooks](https://github.com/RickCoxDev/raspi-k3s) to see how I setup my cluster.

## :computer:&nbsp; Hardware
|      Device     | Count | Memory |             Role            |                                 Notes                                |
|:---------------:|:-----:|:------:|:---------------------------:|:--------------------------------------------------------------------:|
| Raspberry Pi 4B |   1   |   4GB  |          K3s Master         |                                                                      |
| Raspberry Pi 4B |   2   |   4GB  |          K3s Worker         |                                                                      |
| Raspberry Pi 2B |   1   |   1GB  |          K3s Worker         |                                                                      |
| Raspberry Pi 4B |   1   |   2GB  | K3s Worker/Storage Provider | Has a 2TB SSD plugged in and runs openmediavault to provide storage. |

## :building_construction:&nbsp; Project Layout

### Setup
1. Setup Python virtual environment and activate
   ```bash
   python3 -m venv venv
   . venv/bin/activate.fish
   ```
2. Install Python dependencies
   ```bash
   pip install -r ./ansible/requirements.txt
   ```
3. Install Ansible-Galaxy Roles
   ```bash
   ansible-galaxy install -r ./ansible/requirements.yml
   ```
### Ansible

#### Playbooks
| Playbooks | Description                                                                                                      |
|-----------|------------------------------------------------------------------------------------------------------------------|
| k3s       | Does general setup of the Raspberry Pis, installs and setups k3s, and copies kubeconfig to the kubeconfig folder |
| k3s-nuke  | Uninstalls k3 and deletes related files                                                                          |

#### Roles
| Playbooks | Description                                                                                                      |
|-----------|------------------------------------------------------------------------------------------------------------------|
| k3s       | Does general setup of the Raspberry Pis, installs and setups k3s, and copies kubeconfig to the kubeconfig folder |
| k3s-nuke  | Uninstalls k3 and deletes related files                                                                          |

### OMV Setup
After setup, connect a usb drive to the node running OMV. Setup up Shares and activate NFS service.

For each NFS share use the following options:
```
all_squash,insecure,async,no_subtree_check,anonuid=0,anongid=0
```

## :clap:&nbsp; Thanks
I've used the following repos as inspiration and guidelines for this repo.

- [billimek](https://github.com/billimek/k8s-gitops)
- [onedr0p](https://github.com/onedr0p/k3s-gitops)
- [xUnholy](https://github.com/raspbernetes/k8s-gitops)
