from flask import Flask, request, jsonify
import requests

app = Flask(__name__)
UPSTREAM = "http://blockchain:8545" 
BLOCKED_METHODS = {"anvil_setCode", "anvil_setBalance", "anvil_setStorageAt","anvil_autoImpersonateAccount","anvil_reset","anvil_reset","anvil_loadState",
 "anvil_setChainId","anvil_setCoinbase","anvil_setNonce","anvil_dumpState","anvil_nodeInfo","anvil_impersonateAccount","anvil_setRpcUrl","hardhat_setCode", 
 "hardhat_setBalance", "hardhat_setStorageAt","hardhat_autoImpersonateAccount","hardhat_reset","hardhat_reset","hardhat_loadState","hardhat_setChainId","hardhat_setCoinbase",
 "hardhat_setNonce","hardhat_dumpState","hardhat_nodeInfo","hardhat_impersonateAccount","hardhat_setRpcUrl"}

@app.route("/", methods=["POST"])
def rpc_proxy():
    data = request.get_json()

    method = data.get("method")
    if method in BLOCKED_METHODS:
        return jsonify({
            "jsonrpc": "2.0",
            "error": {
                "code": -32601,
                "message": f"Method '{method}' is not allowed"
            },
            "id": data.get("id")
        })

    resp = requests.post(UPSTREAM, json=data)
    return (resp.content, resp.status_code, resp.headers.items())

app.run(host="0.0.0.0", port=9000)