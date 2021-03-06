{-# LANGUAGE DataKinds             #-}
{-# LANGUAGE FlexibleContexts      #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE NoImplicitPrelude     #-}
{-# LANGUAGE NumericUnderscores    #-}
{-# LANGUAGE OverloadedStrings     #-}
{-# LANGUAGE ScopedTypeVariables   #-}
{-# LANGUAGE TypeApplications      #-}
{-# LANGUAGE TypeFamilies          #-}

module Oracle.Trace where

import           Control.Monad              hiding (fmap)
import           Control.Monad.Freer.Extras                   as Extras
import           Plutus.Contract            as Contract
import           Plutus.Trace.Emulator      as Emulator
import           PlutusTx.Prelude           hiding (Semigroup(..), unless)
import           Prelude                    (IO, String, show)
import           Wallet.Emulator.Wallet
import           Test.Tasty
import qualified Test.Tasty.HUnit                             as HUnit
import           Data.Monoid                                  (Last (..))
import           Plutus.Contract.Trace      as X

import           Oracle.OffChain

testContract :: IO ()
testContract = runEmulatorTraceIO oracleTrace

alice, bob, charlie :: Wallet
alice = X.knownWallet 1
bob = X.knownWallet 2
charlie = X.knownWallet 3
delta = X.knownWallet 4

oracleTrace :: EmulatorTrace ()
oracleTrace = do
    h1 <- activateContractWallet alice useOrclEndpoints
    h2 <- activateContractWallet alice walletEndpoint
    let pkhBob = mockWalletPaymentPubKeyHash bob
    callEndpoint @"start" h1 pkhBob
    void $ Emulator.waitNSlots 2
    callEndpoint @"payRewards" h2 ()
    void $ Emulator.waitNSlots 2
    let pkhCharlie = mockWalletPaymentPubKeyHash charlie
    callEndpoint @"update" h1 pkhCharlie
    void $ Emulator.waitNSlots 2
    callEndpoint @"payToTheScript" h2 (8*1000000)
    void $ Emulator.waitNSlots 2
    callEndpoint @"payRewards" h2 ()
    void $ Emulator.waitNSlots 2
    callEndpoint @"payToTheScript" h2 (67*1000000)
    void $ Emulator.waitNSlots 2
    callEndpoint @"payRewards" h2 () -- this will not transfer because oracle is in used state
    void $ Emulator.waitNSlots 2
    let pkhDelta = mockWalletPaymentPubKeyHash delta
    callEndpoint @"update" h1 pkhDelta
    void $ Emulator.waitNSlots 2
    callEndpoint @"payToTheScript" h2 (10*1000000)
    void $ Emulator.waitNSlots 2
    callEndpoint @"payRewards" h2 ()