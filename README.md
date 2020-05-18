# Cardano Haskell Testnet testing #

Cardano Haskell Testnet testing with Docker, using the latest Ubuntu LTS (20.04 as of this writing).

This setup was inspired by Mark Stopka's [Cardano Node Docker Images](https://github.com/2nd-Layer/docker-hub-cardano-images/) with the addition of ```docker-compose```.

## What is it? ##

This Docker setup provides two containers: a ```core node``` and a ```relay node```. It is based on the Pioneer's [node setup guides](https://github.com/input-output-hk/cardano-tutorials/tree/master/node-setup) and will facilitate you to follow the Pioneer's [exercises](https://github.com/input-output-hk/cardano-tutorials/tree/master/pioneers-testnet). Consequentially, it will always track the latest ```pioneer-*``` tag on [the cardano-node repo](https://github.com/input-output-hk/cardano-node/).

## Docker Compose ##

- Docker Compose is used for starting containers on the **same host**.
- Docker Compose is used to facilitate local building and testing, and **it's not suitable for any serious deployment**.
- Docker Compose allows configuring and starting multiple Docker containers.
- Docker Compose is mostly used as a helper when you want to start multiple Docker containers and doesn't want to start each one separately using docker run ....
- Docker Compose is used instead of all optional parameters when building and running a single docker container.

## Usage ##

- Place your ```genesis.json``` in ```common/config/genesis.json```
- Place your ```config.json``` in ```common/config/config.json```
- Place your **core node** ```topology.json``` files in ```core/config/topology.json```
- Place your **relay node** ```topology.json``` files in ```relay/config/topology.json```
- Run ```docker-compose -f docker-compose.yaml up --build -d```

**NOTE:** If the build fails because of the host operating system killing the process for using too many resources, just re-run it until successful. It will eventually work. It helps if ```docker-compose build``` is the only process running  (the 'builder' is a resource hog).

## Configuration Files ##

These used to be secreted, but apparently sharing is allowed now. So, you can find the "Friends and Family" (aka Pioneers) configurations here: [https://hydra.iohk.io/job/Cardano/iohk-nix/cardano-deployment/latest-finished/download/1/index.html](https://hydra.iohk.io/job/Cardano/iohk-nix/cardano-deployment/latest-finished/download/1/index.html)

## Updates ##

I will improve this content over time, as I continue testing and understanding the HTN. Possibly with a guide and instructions to make it so that it will be deployable to Digital Ocean (or any cloud provider). Possibly with [Kubernetes](https://www.youtube.com/playlist?list=PLOspHqNVtKABAVX4azqPIu6UfsPzSu2YN), and many other goodies.

Follow [insaladaPool](https://twitter.com/insaladaPool) on Twitter for updates.

## About Me ###

Should you be wondering about my technical background, [I've been a Linux professional](https://linkedin.com/in/gacallea/) for a long time. I love Open Source, and I've taught people about it. I strongly believe in Cardano. And it was a long time since I last contributed to a project.

I also run the [**Insalada Stake Pool**](https://insalada.io/), and this is what got me into this adventure. Follow [**insaladaPool**](https://twitter.com/insaladaPool) on Twitter for updates.

## Contributions ##

If you have comments, changes, suggestions for the guide and/or the scripts, please [file an issue](https://github.com/gacallea/htn_testing/issues) on Github. Any insight is valuable and will be considered for integration and improvements.

If these resources help you in any way, consider [buying me a beer](https://seiza.com/blockchain/address/Ae2tdPwUPEZHwvuNhu7qGeBcZBTQAwL2SUA49T6CubbQzoxgxyffYJ8VvcW). Delegating [to my pool](https://insalada.io/) would also be nice.
