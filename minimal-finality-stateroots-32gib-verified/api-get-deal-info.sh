#! /bin/bash

PORT=$(lotus auth api-info --perm admin | grep FULLNODE_API_INFO | sed 's,^FULLNODE_API_INFO=.*:,,' | sed 's,/ip4/0.0.0.0/tcp/\([0-9]*\)/http,\1,')
#echo $PORT
TOKEN=$(lotus auth api-info --perm admin | grep FULLNODE_API_INFO | sed 's,^FULLNODE_API_INFO=\(.*\):.*,\1,')
#echo $TOKEN

#curl -X POST  -H "Content-Type: application/json"  -H "Authorization: Bearer $TOKEN"  --data "{ \"jsonrpc\": \"2.0\", \"method\": \"Filecoin.ClientGetDealInfo\", \"params\": [ { \"/\": \"bafyreiecn32ux7igltycohzmhcmhujvrxsw25h3lxlksm36du3iznjwf44\" } ], \"id\": 1 }" http://127.0.0.1:$PORT/rpc/v0 
curl -s -X POST  -H "Content-Type: application/json"  -H "Authorization: Bearer $TOKEN"  --data "{ \"jsonrpc\": \"2.0\", \"method\": \"Filecoin.ClientGetDealInfo\", \"params\": [ { \"/\": \"$1\" } ], \"id\": 1 }" http://127.0.0.1:$PORT/rpc/v0 
