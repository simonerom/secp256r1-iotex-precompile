# secp256r1-iotex-precompile

A basic example demonstrating how to verify a P256 signature on the IoTeX blockchain using the secp256r1 custom precompiled contract implemented in the IoTeX EVM.

## Clone
```shell
git clone https://github.com/simonerom/secp256r1-iotex-precompile.git
cd secp256r1-iotex-precompile
```

- Deploy an ERC20 token on IoTeX 
- Deploy the P256Rewards contract
- Create a local .env file containing an IoTeX private key (checkout https://developers.iotex.io to configure Metamask and fund your testnet account) and the contract address:
```sh
# .env file
IOTEX_PRIVATE_KEY=0xabc...123
SECP256K1_CONTRACT_ADDRESS=0xB420B3f0Ff50a612642d4DcaF663b18e8fb57c85
```

## Run
```sh
npm install
node secp256r1.js
```
