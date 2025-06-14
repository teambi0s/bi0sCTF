export RPC_URL=#RPC_URL
export PRIVATE_KEY=#PRIVATE_KEY

deploy:
	rm -rf ./broadcast/* &&\
	forge script script/Deploy.s.sol:Deploy --rpc-url $(RPC_URL)  --private-key $(PRIVATE_KEY) --broadcast

