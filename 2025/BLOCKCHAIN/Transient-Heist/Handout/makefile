export ANVIL_RPC_URL=#YOUR RPC URL
export PRIVATE_KEY=#PK

anvil:
	anvil -a 1 --balance 451078305590476002
deploy: create-contracts

create-contracts: create-bi0sSwap-factory
	forge script script/Deploy.s.sol:Deploy --rpc-url $(ANVIL_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast "$(V)"

create-bi0sSwap-factory:
	rm -rf broadcast/* && forge create src/bi0s-swap-v1/Bi0sSwapFactory.sol:Bi0sSwapFactory \
		--rpc-url $(ANVIL_RPC_URL) \
		--private-key $(PRIVATE_KEY) \
		--broadcast \
		--constructor-args 0000000000000000000000000000000000000000 



