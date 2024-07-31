# cometbft-test
Testing helpers for cometbft &amp; tm-load-test

# Prerequisites

## Go

First, you need Go installed. `tm-load-test` was tested with Go 1.20, but it looks like it works fine with the Go 1.18 that comes by default with Ubuntu 22.04.

```
sudo apt-get update
sudo apt-get install golang
```

If not, you can install Go from its distribution channels to get a fresh version.

## tm-load-test

`tm-load-test` is a process that connects to a cometbft validator(?) node via its RPC port and dumps a bunch of transactions into the network. It seems to work if the cometbft network is running the default, in-process "kv-store" ABCI application that comes bundled in the cometbft binary.

You need to clone it somewhere, then build it using Go.

```
git clone https://github.com/informalsystems/tm-load-test
cd tm-load-test
make
```

This should create a `tm-load-test/build/tm-load-test` executable.

## cometbft

Lazy version (gets cometbft v0.38.10):

```
download_cometbft.sh
```

Detailed version:

Get the `cometbft` executable from the binary release (e.g. amd64 linux, version v0.38.10 which right now is the latest one, or whatever is the newest): https://github.com/cometbft/cometbft/releases

Just copy over the `cometbft` executable in the root directory of this repository. The `.gitignore` file will already exclude it, and the `*.sh` scripts that come with this repo will find it there.

# Running a testnet

## Creating the node data directories

Run the `create_nodes.sh` script, passing one argument to it, which is the number of nodes in the network. It will create a bunch of `n[xx]/` subdirectories (excluded by `.gitignore`), where each one is a data directory for one of the nodes of the same simulated blockchain.

## Tweaking configuration values

For parameters that are set per node, run `set.sh <property_name>` to find and print the current value of a configuration property across all `n[xxx]/config/config.toml` files. Then, to change the value, use `set.sh <property_name> <property_value>`, for example: `set.sh send_rate 51200000`, `set.sh recv_rate 51200000`.

To change the max block size in the `genesis.json` file of each node, you can change the `genesis.json` file that is at the root directory of the project (it is created after you call `create_nodes.sh`) to have the values that you want, and then you can run `copy_genesis.sh` to overwrite the `genesis.json` file of each `nxxx/` node (at `nxxx/config/genesis.json`).

## Running the nodes

Then, run `start_nodes.sh` which will scan for these directories and start the appropriate number of nodes. Each node will spawn one empty terminal that prints nothing, because all output will be directed to `n[xx]/cometbft.log` which you can `tail -f` in another window, for example.

If there are problems (e.g. the node creation script needs some fixing/tweaking...) just close/kill all of the `cometbft` processes and remove all `n[xx]` directories to start over.

NOTE: `cometbft` also comes with a `cometbft testnet` command that generates a testnet with multiple data directories. That should also work, but then we will still need to tweak the parameters like block sizes, etc. and those parameters can be changed inside `create_nodes.sh`. We can also create another script that tweaks the `cometbft testnet` after it is created.

## Resetting the node data

To start all created nodes from scratch (block 0 / genesis) again, run `reset_nodes.sh`. This resets the `n[xx]/data/` dir of each node to the default, and also deletes the `cometbft.log` log file for each node. Make sure to call this after you have stopped all cometbft processes.

# Running the load test on a running testnet

To run the load test, copy over `load_test.sh` to the same directory where `tm-load-test` was built, and run it there. You can open the shell script and tune the parameters. This script just connects to one validator node's RPC port, generates traffic to the blockchain through that node, and then prints the e.g. TPS rate that was obtained to `stats.csv`.


