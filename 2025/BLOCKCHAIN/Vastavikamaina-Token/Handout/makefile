export ANVIL_RPC_URL=#RPC_URL
export PRIVATE_KEY=#PRIVATE_KEY

deploy: create-contracts

create-contracts: create-uniswap-factory
	forge script script/Deploy.s.sol:Deploy --rpc-url $(ANVIL_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast "$(V)"

create-uniswap-factory:
	rm -rf broadcast/* && forge create src/uniswap-v2/UniswapV2Factory.sol:UniswapV2Factory \
		--rpc-url $(ANVIL_RPC_URL) \
		--private-key $(PRIVATE_KEY) \
		--broadcast \
		--constructor-args 0000000000000000000000000000000000000000 

