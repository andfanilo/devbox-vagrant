# My Devbox

Devbox is built upon [JHispter Devbox](https://github.com/jhipster/jhipster-devbox).

Prerequisites on VirtualBox :

- [VirtualBox](https://www.virtualbox.org/)
- [VirtualBox guest additions](https://www.virtualbox.org/manual/ch04.html)
- [Vagrant](https://www.vagrantup.com/)
- [vagrant-disksize](https://github.com/sprotheroe/vagrant-disksize)
- if proxy, [vagrant-proxyconf](https://github.com/tmatilai/vagrant-proxyconf)

What you get :

- Ubuntu Bionic configured with Oh My ZSH
- Node, NPM, Yarn
- Docker, Docker Compose (for starting DBs like Postgres, MongoDB)
- Chromium, Firefox Web browsers
- Miniconda
- pgAdmin, Mongo client

## Usage

On Windows :

```
vagrant up --provider virtualbox
vagrant ssh
```

Log build machine : `vagrant up > vagrant.log 2> error.log`.

Stop machine : `vagrant halt`.

Destroy machine : `vagrant destroy`.

Package box :

```
vagrant package --output devbox.box
vagrant box add --force devbox devbox.box
vagrant init devbox
```
