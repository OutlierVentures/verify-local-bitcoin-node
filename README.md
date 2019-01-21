# Sync a Bitcoin Core node from a specific source node

Scripts to automate syncing a Bitcoin Core node ("verifier node") from a specific Bitcoin node ("source node") on your LAN. The scripts are for usage on the verifier node.

Use case: verifying the blockchain data from a preconfigured Bitcoin node like [Casa Node](https://keys.casa/lightning-bitcoin-node/).

## Dependencies

* Tested on Ubuntu 18.04. Will likely work on other Unix-like systems.
* Bitcoin Core
* `ufw` firewall
* Root access to the machine
* A source node on the same IPv4 LAN subnet as the verifier node running some Bitcoin node software

## Warning

**These scripts will mess up the firewall configuration on the machine they are run on.** Best use them on a clean VM used only for this purpose, e.g. using Vagrant. The network access of the machine will be restricted to the LAN during the verification, which makes it pretty much unusable for any other purpose.

# Usage

1. Set up an empty clean folder for `bitcoind` to use.
2. Create a `config` file. Use `config.example` as a start.
3. Use `start-bitcoind-only-source-node.sh` to start verifying the source node, with outgoing network access restricted to the configured LAN subnet.
4. While syncing, optionally use `watch-stats.sh` and `tail-debug-log.sh` to check progress.
5. When syncing is complete, use `start-bitcoind-normal.sh` to open up outgoing network traffic and run `bitcoind` normally.

## Scripts

The scripts are found under `scripts/`.

Managing `bitcoind`:

- `start-bitcoind-only-source-node.sh` - Start the `bitcoind` process to sync only from the source node with restricted network access
- `start-bitcoind-normal.sh` - Start the `bitcoind` process in normal node, allowing access to all nodes on the network
- `stop-bitcoind.sh` - Stop the running `bitcoind` process
- `bitcoin-cli.sh` - Call `bitcoin-cli` to interface directly with the verifier node

Stats and diagnostics:
- `stats.sh` - Show some statistics about the running `bitcoind` process
- `watch-stats.sh` - Show `stats.sh` every 10 seconds
- `tail-debug-log.sh` - Show `bitcoind`'s `debug.log` as it is being written to
- `less-debug-log.sh` - Open `bitcoind`'s `debug.log`

Helper scripts:
- `read-config.sh` - Read the config file
- `firewall-full-outgoing.sh` - Configure the firewall to allow outgoing traffic
- `firewall-only-lan-outgoing.sh` - Configure the firewall to only allow traffic to the LAN as configured in `config`

# Tips and troubleshooting

## Speeding up the blockchain sync with a small SSD

The total Bitcoin blockchain at time of writing requires 226GB of free space, and is ever growing. If you have a lot of slow storage (a large HD) and some fast storage (a small SSD), you can speed up the syncing process a lot by keeping the `chainstate` directory on your SSD while leaving the `blocks` directory on your HD. Use symlinks or some other form of mounting / linking.

[Source](https://www.reddit.com/r/Bitcoin/comments/7iaa3t/if_you_run_a_full_node_on_a_hdd_put_your/)

## The syncing process stalls after a while

Bitcoin Core has a configuration option [`maxuploadtarget`](https://bitcoin.org/en/full-node#reduce-traffic). If the source node is running Bitcoin Core and this option is set to a non-zero value, it will throttle the network traffic as soon as it comes close to that value. You'll experience this as follows:

1. Syncing starts quickly
2. After a while, no new block data comes in for exactly 10 minutes
3. After exactly 10 minutes, some more block data comes in
4. Go to 2, repeat

On [Casa Node](https://keys.casa/lightning-bitcoin-node/), this value is set to 5000 MB per 24h by default. To work around that, change the `maxuploadtarget` configuration on the source node. If you're unable or unwilling to access the configuration on the source node, restarting it will also work, because the network traffic used is not remembered by `bitcoind` over multiple . Note that you might have to restart it many times.

# FAQ

## How long does syncing take?

It depends, to a large extent on the storage speed, CPU speed and available memory on the verifier node, in that order. In my case it took about five days on a VM with 4GB RAM, 2 cores, the `chainstate` directory on an SSD and the `blocks` directory on a HD.

## How do I know when it's done?

Check `debug.log`, for example using `tail-debug-log.sh`. Look for the value `progress=[number]`. This number will start at 0, and reach 1 when syncing is complete. You can also check the value `date='...'`, which shows the date of the last imported block in UTC.

For example:

```
2019-01-21T13:04:56Z UpdateTip: new best=000000000000000000288652b07fa0bfc4cfce087dd75ff3f674b4d8ae02d02a height=559468 version=0x20000000 log2_work=90.262056 tx=375236324 date='2019-01-21T13:04:39Z' progress=1.000000 cache=3.3MiB(25281txo) warning='44 of last 100 blocks have unexpected version'
```

Besides this, you can use external sources like [blockchain.com's block explorer](https://www.blockchain.com/explorer) and check how many blocks are left. You can also check [what the current blockchain size is](https://www.blockchain.com/charts/blocks-size?timespan=all) and how much data your node has left to process.

## When my verifier node is fully synced, what have I learned?

If your verifier node is fully synced, and you have confirmed that latest block hashes are identical to some other data source of the Bitcoin blockchain (perhaps a block explorer or some other Bitcoin full node you run yourself), you have a strong guarantee that the source node contains the complete and correct Bitcoin blockchain data, and is able to serve it following the Bitcoin protocol.

## What *doesn't* this verify?

A lot! There could be malware on the source node, it could steal your private keys, it could keep some invalid set of blockchain data which it only serves to certain nodes or at full moon in leap years. It could set your house on fire in your sleep, or organise a party for its friends at your house while you're out. These scripts won't help you detect or prevent any of that.

Bottom line, these scripts only help to confirm whether the node is able to serve the correct and complete Bitcoin blockchain data following the Bitcoin protocol.


