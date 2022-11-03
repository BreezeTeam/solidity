use std::convert::TryFrom;
use std::env::VarError;
use std::sync::Arc;
use std::env;
use std::error::Error;
use dotenv::dotenv;


use ethers::core::k256::elliptic_curve;

use ethers::prelude::{Address, LocalWallet, ProviderError};
use ethers::providers::{Http, Provider, Ws};
use rustc_hex::FromHexError;

pub struct Env {
    // pub local_wallet: LocalWallet,
    pub wss_provider: Arc<Provider<Ws>>,
    pub http_providers: Vec<Arc<Provider<Http>>>,
    pub contract_to_watch: Arc<Address>,
    pub bnb_address: Arc<Address>,
    pub desired_token: Arc<Address>,
}

#[warn(unused_imports)]
impl Env {
    pub async fn new() -> Result<Self, EnvSetUpError> {
        dotenv().ok();

        for (k, v) in env::vars() {
            println!("{},{}", k, v);
        }
        // pvt wallet
        // let local_wallet = env::var("mtmsk_acc").map(|pvt_key| pvt_key.parse::<LocalWallet>())??;

        // token addresses we are going to deal with
        let desired_token = Env::parse_arced_address("desired_token_address")?;

        // bnb address
        let bnb_address = Env::parse_arced_address("wbnb_address")?;

        // contacts to watch
        let contract_to_watch = Env::parse_arced_address("contract_to_watch")?;

        // http providers
        let http_providers = env::var("http_providers")?;
        println!("http_providers:{}", http_providers);
        let http_providers: Vec<Arc<Provider<Http>>> = http_providers
            .split("|")
            .map(|provider_url| {
                Arc::new(Provider::<Http>::try_from(provider_url).expect(&format!(
                    "Error creating Http provider from url {}",
                    provider_url
                )))
            })
            .collect();

        // wss provider
        let wss_provider = env::var("wss_provider_url")?;
        println!("wss_provider:{}", wss_provider);
        // let wss_provider: Arc<Provider<Http>> = Arc::new(Provider::<Ws>::try_from(wss_provider).expect(&format!(
        //             "Error creating Http provider from url {}",
        //             wss_provider
        //         )))
        //

        let ws = Ws::connect(wss_provider).await
            .expect("Error while making WebSocket connection");
        let wss_provider = Arc::new(Provider::new(ws).interval(std::time::Duration::from_millis(30)));

        // let ws = Ws::connect(wss_provider)
        //     .await
        //     .expect("Error while making WebSocket connection");
        // let wss_provider =
        //     Arc::new(Provider::new(ws).interval(std::time::Duration::from_millis(30)));

        Ok(Env {
            // local_wallet,
            wss_provider,
            http_providers,
            contract_to_watch,
            bnb_address,
            desired_token,
        })
    }
    fn parse_arced_address(env_var: &str) -> Result<Arc<Address>, EnvSetUpError> {
        let arc = env::var(env_var)
            .map(|add_str| add_str.parse::<Address>())?
            .map(|address| Arc::new(address))?;
        Ok(arc)
    }
}


// new error for Env to do setting convert
#[derive(Debug)]
pub struct EnvSetUpError {
    error_msg: String,
}

// error convert
impl From<VarError> for EnvSetUpError {
    fn from(err: VarError) -> Self {
        EnvSetUpError {
            error_msg: err.to_string(),
        }
    }
}

// error convert
impl From<elliptic_curve::Error> for EnvSetUpError {
    fn from(err: elliptic_curve::Error) -> Self {
        EnvSetUpError {
            error_msg: err.to_string(),
        }
    }
}

// error convert
impl From<FromHexError> for EnvSetUpError {
    fn from(err: FromHexError) -> Self {
        EnvSetUpError {
            error_msg: err.to_string(),
        }
    }
}

// error convert
impl From<ProviderError> for EnvSetUpError {
    fn from(err: ProviderError) -> Self {
        EnvSetUpError {
            error_msg: format!("{:?}", err),
        }
    }
}

// error convert
// impl From<ProviderError> for EnvSetUpError {
//     fn from(err: ProviderError) -> Self {
//         EnvSetUpError {
//             error_msg: format!("{:?}", err),
//         }
//     }
// }
// impl From<EnvSetUpError> for Box<dyn std::error::Error>{
//     fn from(_: EnvSetUpError) -> Self {
//         let x = Error {
//             error_msg: format!("{:?}", err),
//         };
//         return x
//     }
// }