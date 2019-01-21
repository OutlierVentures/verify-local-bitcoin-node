# Sync a Bitcoin Core node from a specific source node

Scripts to automate syncing a Bitcoin Core node ("verifier node") from a specific Bitcoin Core node ("source node") on your LAN. The scripts are for usage on the verifier node.

Use case: verifying the blockchain data from a preconfigured Bitcoin node like [Casa Node](https://keys.casa/lightning-bitcoin-node/).

## Dependencies

* Tested on Ubuntu 18.04. Will likely work on other Unix-like systems.
* Bitcoin Core
* `ufw` firewall
* Root access to the machine
* A source node running Bitcoin Core on the same IPv4 LAN subnet as the verifier node

## Warning

*These scripts will mess up the firewall configuration on the machine they are run on.* Best use them on a clean VM used only for this purpose, e.g. using Vagrant. The network access of the machine will be restricted to the LAN during the verification, which makes it pretty much unusable for any other purpose.

# Usage

1. Set up an empty clean folder for `bitcoind` to use.
2. Create a `config` file. Use `config.example` as a start.
3. Use `start-bitcoind-only-source-node.sh` to start verifying the source node, restricted network access to LAN.
4. While syncing, optionally use `watch-stats.sh` and `tail-debug-log.sh` to check progress.
5. When syncing is done, use `start-bitcoind-normal.sh` to open up outgoing network traffic and run `bitcoind` normally.

## Scripts

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

# FAQ

## How long does syncing take?

It depends, to a large extent on the storage speed, CPU speed and available memory on the verifier node, in that order. In my case it took about five days on a VM with 4GB RAM, 2 cores, the `chainstate` directory on an SSD and the `blocks` directory on a HD.

