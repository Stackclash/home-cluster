<h1 align="center">
  My Home Kubernetes Cluster
  <br />
  <br />
  <img width="200" height="200" src="https://upload.wikimedia.org/wikipedia/commons/thumb/3/39/Kubernetes_logo_without_workmark.svg/1200px-Kubernetes_logo_without_workmark.svg.png">
</h1>
<br />
<div align="center">

[![Discord](https://img.shields.io/badge/discord-chat-7289DA.svg?maxAge=60&style=for-the-badge&logo=discord)](https://discord.gg/DNCynrJ) [![k3s](https://img.shields.io/badge/k3s-v1.25.3+k3s1-blue?style=for-the-badge&logo=kubernetes)](https://k3s.io/) [![GitHub last commit](https://img.shields.io/github/last-commit/rickcoxdev/home-cluster?logo=github&style=for-the-badge)](https://github.com/RickCoxDev/home-cluster/commits/main)

</div>

---

## :telescope:&nbsp; Overview
This repo is my home Kubernetes cluster declared using yaml files. The Kubernetes flavor I use is [k3s](https://k3s.io) to keep the size to a minimum. I use [Flux](https://fluxcd.io) to watch this repo and deploy any changes I push here. See below for hardware, repo structure, and setup.

## :computer:&nbsp; Hardware
Previously my cluster was made up of 5 Raspberry Pi boards. I've moved to 7 Dell Wyse 5020 (Dx0Q), all of them using the Fedora 36 Server OS. For storage one of my nodes has a 2TB external hard drive attached and is running a NFS server. Persistent volumes are provisioned using nfs-subdir-provisioner.

## :building_construction:&nbsp; Repo Details

### Folder Structure
The following are the main folders of the repositories.

- **cluster**: Contains all the yamls for the cluster applications and setup.
- **provision**:
  - **ansible**: Playbooks to install k3s on the nodes and setup the cluster
  - **terraform**: Declarations to setup the dns primary dns record to expose the cluster services.

## :clap:&nbsp; Thanks
I've used the following repos as inspiration and guidelines for this repo.

- [billimek](https://github.com/billimek/k8s-gitops)
- [onedr0p](https://github.com/onedr0p/k3s-gitops)
- [xUnholy](https://github.com/raspbernetes/k8s-gitops)

A special thanks goes to onedr0p for his [flux cluster template](https://github.com/onedr0p/flux-cluster-template). I recently reorganized my repo to closely follow his template.