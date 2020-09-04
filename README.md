# filecoin-wiki-test

This repo contains metadata and scripts for storing a test set of
data on the Filecoin testnet.

## Dataset

The current data set is an English Kiwix zip file - 3.1GB (approximately
1/10th of a sector), but separated into approximately 700 ~5MB chunks
suitable for use directly from within a web browser using the Lotus
JSON-RPC API.

## Client Wallet Addresses

Over time, we will attempt to store and retrieve the content.

The set of client addresses that have been used to make deals are currently:

* t03296 - t3qfrxne7cg4ml45ufsaxqtul2c33kmlt4glq3b4zvha3msw4imkyi45iyhcpnqxt2iuaikjmmgx2xlr5myuxa
* t08106 - t3rey7pw2asdskrqpretcbnxjczkyr4lyindagouytbxtigbhihdwz4sxfwhf5m4cpofdd23huxraq4tmwmera
* t015968 - t3v2zpeguwiruv337whycttt362nn5yrzzurtb62dad7sqxdsgzlaj5mpgmw6rh2arlsufyvlgssduaqusmkya

# Format

The deal and cid information is stored in this git repository as a series of small text files
and dumps from the lotus comman line. Over time, we will be experimenting with IPLD to more
efficiently store and replicate the data between systems without using git.

# License

MIT
