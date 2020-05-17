# htn_testing #

Cardano Haskell Testnet testing with Docker (using the latest Ubuntu LTS (20.04 as of this date))

This setup was inspired by Mark Stopka's https://github.com/2nd-Layer/docker-hub-cardano-images/ with the addition of ```docker-compose``` and a few other things.

Will improve over time and possibly make it so that it will be deployable to Digital Ocean (or any cloud provider), possibly with [Kubernetes](https://www.youtube.com/playlist?list=PLOspHqNVtKABAVX4azqPIu6UfsPzSu2YN).

## docker-compose ##

- Docker Compose allows configuring and starting multiple Docker containers.
- Docker Compose is mostly used as a helper when you want to start multiple Docker containers and doesn't want to start each one separately using docker run ....
- Docker Compose is used for starting containers on the **same host**.
- Docker Compose is used instead of all optional parameters when building and running a single docker container.

## configurations ##

- Place your ```genesis.json``` in ```common/config/genesis.json```
- Place your ```config.json``` in ```common/config/config.json```
- Place your **core node** ```topology.json``` files in ```core/config/topology.json```
- Place your **relay node** ```topology.json``` files in ```relay/config/topology.json```
- Run ```docker-compose -f docker-compose.yaml up --build -d```

## updates ##

This repo will evolve and improve as I continue testing and understanding the HTN, possibly with a guide and instructions. Follow [insaladaPool](https://twitter.com/insaladaPool) on Twitter for updates.
