use std::convert::TryFrom;
use std::env;
use std::env::VarError;
use std::error::Error;
use std::sync::Arc;

use dotenv::dotenv;
use ethers::core::k256::elliptic_curve;
use ethers::prelude::{Address, BlockNumber, LocalWallet, Middleware, ProviderError};
use ethers::providers::{Http, Provider, Ws};
use ethers::types::U64;
use rustc_hex::FromHexError;

#[derive(Clone)]
pub struct Env {
    // pub local_wallet: LocalWallet,
    pub wss_provider: Arc<Provider<Ws>>,
    pub http_providers: Vec<Arc<Provider<Http>>>,
    pub contract_to_watch: Address,
    pub bnb_address: Address,
    pub desired_token: Address,
    pub swap_contract: Address,
    pub last_block: U64,
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
        let desired_token = Env::parse_address("desired_token_address")?;
        let swap_contract = Env::parse_address("swap_contract")?;

        // bnb address
        let bnb_address = Env::parse_address("wbnb_address")?;

        // contacts to watch
        let contract_to_watch = Env::parse_address("contract_to_watch")?;

        // connection http from uri
        let http_providers = env::var("http_providers")?;
        let http_providers: Vec<Arc<Provider<Http>>> = http_providers
            .split("|")
            .map(|provider_url| {
                Arc::new(Provider::<Http>::try_from(provider_url).expect(&format!(
                    "Error creating Http provider from url {}",
                    provider_url
                )))
            })
            .collect();


        // connection websocket from uri
        let wss_provider = env::var("wss_provider_url")?;
        let ws = Ws::connect(wss_provider).await.expect("Error while making WebSocket connection");
        let wss_provider = Arc::new(Provider::new(ws).interval(std::time::Duration::from_millis(30)));

        let last_block = U64::MAX;
        Ok(Env {
            // local_wallet,
            wss_provider,
            http_providers,
            contract_to_watch,
            bnb_address,
            desired_token,
            swap_contract,
            last_block,
        })
    }


    // Mutable access.
    pub async fn last_block(&mut self) -> u64 {
        if self.last_block == U64::MAX {
            self.last_block = match self.wss_provider.get_block(BlockNumber::Latest).await {
                Err(_) => U64::MAX,
                Ok(d) => d.unwrap().number.unwrap(),
            };
        }
        self.last_block.as_u64()
    }

    // parse address from env
    fn parse_address(env_var: &str) -> Result<Address, EnvSetUpError> {
        let arc = env::var(env_var)
            .map(|add_str| add_str.parse::<Address>())?
            .map(|address| address)?;
        Ok(arc)
    }
}


// new error for Env to do setting convert
#[derive(Debug)]
#[warn(dead_code)]
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