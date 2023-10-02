import { ethers } from 'ethers';
import { useEffect, useState } from 'react';


export default function InitWalletComponent() {
  const [error, setError] = useState(null);
  const CHAIN_ID = '31337';
  const ENVIRONMENT = 'local';

  useEffect(() => {
      init().catch((error)=> {
        setError(error);
      });
  // eslint-disable-next-line react-hooks/exhaustive-deps    
  }, []);

  async function init() {
    if (!window.ethereum) throw new Error(`User wallet not found`);


    let unlocked = await isUnlocked();
    while(!unlocked){
      console.log('Waiting for user to unlock the wallet');
      unlocked = await isUnlocked();
      if(unlocked){
        location.reload();
      }
      await new Promise(resolve => setTimeout(resolve, 5000));
    }


    const userProvider = new ethers.providers.Web3Provider(window.ethereum);
    const userNetwork = await userProvider.getNetwork();
    console.log(`Current user wallet chain id is: ${userNetwork.chainId.toString()}`);
    console.log(`Current configured chain id is: ${CHAIN_ID}`);


    window.ethereum.on("accountsChanged", (accounts) => {
      location.reload();
    });


    window.ethereum.on("chainChanged", (chainId) => {
      location.reload();
    });
   
    if (userNetwork.chainId.toString() !== CHAIN_ID) throw new Error(`Please connect your wallet to ${ENVIRONMENT} network.`);
  }


  async function isUnlocked() {
    const provider = new ethers.providers.Web3Provider(window.ethereum);


    let unlocked;


    try {
        const accounts = await provider.listAccounts();


        unlocked = accounts.length > 0;
    } catch (e) {
      unlocked = false;
    }


    return unlocked;
}


  if (error) {
    throw error;
  }
  return (<div></div>);
}



