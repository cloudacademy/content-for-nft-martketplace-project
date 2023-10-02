import '../styles/globals.css'
import HeaderComponent from "../components/header.js";
import InitWalletComponent from '../components/init-wallet';

function MyApp({ Component, pageProps }) {
  return (
    <div className="flex flex-col items-center bg-slate-100 ">
      <InitWalletComponent></InitWalletComponent>
      <HeaderComponent></HeaderComponent>            
      <Component {...pageProps} />
    </div>
  );
}

export default MyApp
