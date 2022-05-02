### Revenue Sharing Tokens (RSTs)

In the context of token utilities, revenue sharing is probably one of the most fundamental use cases. Just like owning some shares of a company that pays dividends, by holding some RSTs you receive your shares of the profit made by the platform that issued the RSTs.
By issuing and selling RSTs, new platforms can raise money from crypto investors who believe in their project and in what they are building.

RST smart contract functionality
The most straightforward way of distributing revenue to RST holders is to send them their respective share of the platform's income based on a specified frequency. This approach, although, eventually leads to high transaction fees, proportional to the number of RST holders and also on the distribution frequency.

To avoid this issue, two main strategies can be used:
Decreasing the frequency at which rewards are distributed
Picking some RST holders randomly to receive rewards at that each rewards distribution batch

This project employs the second approach above.
The RST holders can be identified by querying the Cardano blockchain.
The randomly selected holder for next payout is then stored at an oracle. There has to be a wallet designated as the controlling wallet for starting and updating the oracle. 
The rewards are determined by the parameters defined by the platform owner, such as frequency and percentage of RST holders to receive funding each distribution round, for example.
The rewards are accumulated at a script address. Here the oracle address also acts as the storage for the rewards. The rewards get transferred to the beneficiary stored at the oracle everytime the controlling wallet initiates a trasnfer. 

This is an illustration of how the revenue sharing smart contract can be integrated with a platform with one or more revenue streams.
![Revenus sharing SC](https://user-images.githubusercontent.com/5955141/166177399-09d5fe78-40c3-4dcd-8323-ab0e3365a6e4.jpg)


#### Endpoints in the smart contract

- startOracle 
- updateOracle
- payToTheScript
- payRewards

### Using this repo
Build the modules
```
cabal build revenue-sharing-contract oracle-pab start-oracle update-oracle send-rewards pay-to-script
```

Follow the setup for cardano-node, chain-index and wallet server as detailed in IOG's plutus-apps repo.

Run PAB (once the above components are up and in sync) using the following scripts
```
rsc-migrate-pab.sh
rsc-start-pab.sh
```

Set up:
Set the env variable for wallet id for the wallet that controls the oracle as $WID.

Use the corresponding scripts for the following operations
- Start oracle - `rsc-start-oracle-haskell.sh` with argument as the next beneficiary pkh
- Update oracle - `rsc-migrate-pab.sh`  with argument as the next beneficiary pkh
- Add utxo to script to be paid to beneficiary - `rsc-pay-to-script-haskell.sh`  with argument as the amount in lovelaces
- Initiate transfer of amount to the beneficiary - `rsc-send-rewards-haskell.sh` 

Thanks!
