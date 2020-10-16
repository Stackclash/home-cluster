<h1 align="center">
  My Home Kubernetes Cluster
  <br />
  <br />
  <img src="https://raspbernetes.github.io/img/logo.svg">
</h1>
<br />
<div align="center">

[![Discord](https://img.shields.io/badge/discord-chat-7289DA.svg?maxAge=60&style=plastic&logo=discord)](https://discord.gg/DNCynrJ) [![k3s](https://img.shields.io/badge/k3s-v1.18.9-blue?style=plastic&logo=kubernetes)](https://k3s.io/) [![GitHub last commit](https://img.shields.io/github/last-commit/rickcoxdev/k3s-gitops?color=purple&style=plastic)](https://github.com/onedr0p/k3s-gitops/commits/master)

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

## :clap:&nbsp; Thanks
I've used the following repos as inspiration and guidelines for this repo.

- [billimek](https://github.com/billimek/k8s-gitops)
- [onedr0p](https://github.com/onedr0p/k3s-gitops)
- [xUnholy](https://github.com/raspbernetes/k8s-gitops)