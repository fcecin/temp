# Run this script on the directory where you cloned the tm-load-test project
#   and built it (tm-load-test/build)

# After you run the cometbft blockchain, this connects to the first node and sends a bunch of transactions, then generates stats.csv with the TPS rate

# -r 40960 is the tx rate per seconds to generate
# -s 250 is the tx size in bytes
# -T 60 is to generate traffic for 60 seconds
# -c 1 is 1 connection (not sure why this matters)
# the endpoints is the RPC endpoint of the first node (n1) from create_nodes.sh

tm-load-test -c 1 -T 60 -r 40960 -s 250     --broadcast-tx-method async     --endpoints ws://127.0.0.1:26650/websocket     --stats-output stats.csv
