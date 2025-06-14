export ANVIL_RPC_URL=http://blockchain:8545
export ANVIL_PK=0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

anvil:
	anvil -a 1 --balance 451078305590476002
deploy: create-contracts

create-contracts: create-bi0sSwap-factory
	forge script script/Deploy.s.sol:Deploy --rpc-url $(ANVIL_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast "$(V)" --contracts src/core/ --use 0.8.24

create-bi0sSwap-factory:fund-newkeypair
	rm -rf broadcast/* && forge create src/bi0s-swap-v1/Bi0sSwapFactory.sol:Bi0sSwapFactory \
		--rpc-url $(ANVIL_RPC_URL) \
		--private-key $(PRIVATE_KEY) \
		--broadcast \
		--constructor-args 0000000000000000000000000000000000000000 


fund-newkeypair:generate-wallet
	$(eval WALLET_ADDRESS := $(shell grep 'Address:' wallet.txt | awk '{print $$2}'))
	$(eval PRIVATE_KEY := $(shell grep 'Private key:' wallet.txt | awk '{print $$3}'))
	$(eval BAL := $(shell cast balance 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 --rpc-url $(ANVIL_RPC_URL)))
	$(eval MINUS := $(shell cast --to-dec $(shell cast --to-wei 0.1 ether)))
	$(eval AMOUNT := $(shell python3 -c "print($(BAL) - $(MINUS))"))
	@cast send $(WALLET_ADDRESS) --value $(AMOUNT) --private-key $(ANVIL_PK) --rpc-url $(ANVIL_RPC_URL)

generate-wallet:
	@cast wallet new > wallet.txt
	

