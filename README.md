# smileycoin-docker

A docker image for the smileycoin wallet.

## Usage

Start by downloading the image

    docker pull ingimarsson/smileycoin-docker

It is recommended to create a named volume for wallet data

    docker volume create --name="smileycoin_data"

Now the wallet can be started but it will complain about missing
configuration

    docker run ingimarsson/smileycoin-docker

The missing username and password can be added like this

    sudo docker run -v smileycoin_data:/data \
        ingimarsson/smileycoin-docker \
        sh -c "echo rpcuser=smileycoinrpc >> /data/smileycoin.conf"

Make sure to use a safe password

    sudo docker run -v smileycoin_data:/data \
        ingimarsson/smileycoin-docker \
        sh -c "echo rpcpassword=smiley123 >> /data/smileycoin.conf"

The wallet can then be started in detached mode with

    docker run -v smileycoin_data:/data -d ingimarsson/smileycoin-docker

Verify that the container is running by running `docker ps`

    docker ps
    CONTAINER ID        IMAGE                           COMMAND                
    37e53da32617        ingimarsson/smileycoin-docker   "/entrypoint.sh smil…" 

Now we can interact with the wallet

    docker exec 37e smileycoin-cli -datadir=/data getinfo

If you want to expose the RPC port, add `-p 14242:14242` in front of the run
command.
