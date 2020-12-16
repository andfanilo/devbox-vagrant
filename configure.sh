#!/bin/bash

# Configure git (pretty branch with https://stackoverflow.com/questions/1838873/visualizing-branch-topology-in-git/34467298#34467298
cp /vagrant/gitconfig /home/vagrant/.gitconfig

# Configure ZSH for anaconda
/miniconda/bin/conda init zsh
