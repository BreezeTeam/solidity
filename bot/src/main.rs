use std::error::Error;

use chrono::prelude::*;
use ethers::{abi::AbiDecode, prelude::*, utils::keccak256};
use ethers::providers::Middleware;

// use tracing::{Instrument, Level};
use block_bot::demo::env_setup::Env;

abigen!(
    UniswapV2Router,
    r#"[
        removeLiquidity(address tokenA,address tokenB, uint liquidity,uint amountAMin, uint amountBMin, address to, uint ) external returns (uint amountA, uint amountB)
    ]"#,
);

abigen!(
    UniswapV2Pair,
    r#"[
        approve(address,uint256)(bool)
        getReserves()(uint112,uint112,uint32)
        token0()(address)
        token1()(address)
    ]"#
);

// abigen!(
//     UniswapV2Router02,
//     r#"[
//         Swap(index_topic_1 address sender, uint256 amount0In, uint256 amount1In, uint256 amount0Out, uint256 amount1Out, index_topic_2 address to)View Source
//     ]'"#
//     );
fn main() -> Result<(), Box<dyn Error>> {
    // create runtime
    let runtime = tokio::runtime::Builder::new_multi_thread()
        .worker_threads(3)
        .enable_all()
        .build()
        .unwrap();

    // env initialization
    let mut env = runtime.block_on(runtime.spawn(Env::new()))?.unwrap();

    // get last block


    // show transfer
    // runtime.spawn(wss_show_transfer(&env));
    // runtime.block_on()?.unwrap();
    runtime.block_on(runtime.spawn(wss_show_swap(env)))?.unwrap();

    loop {}
    Ok(())
}


fn test_http() {

    // let from = accounts[0];
    // let to = accounts[1];
    //
    // let tx = TransactionRequest::new().to(to).value(1000).from(from); // specify the `from` field so that the client knows which account to use
    //
    // let balance_before = provider.get_balance(from, None).await?;
    // let nonce1 = provider.get_transaction_count(from, None).await?;
    //
    // // broadcast it via the eth_sendTransaction API
    // let tx = provider.send_transaction(tx, None).await?.await?;
    //
    // println!("{}", serde_json::to_string(&tx)?);
    //
    // let nonce2 = provider.get_transaction_count(from, None).await?;
    //
    // assert!(nonce1 < nonce2);
    //
    // let balance_after = provider.get_balance(from, None).await?;
    // assert!(balance_after < balance_before);
    //
    // println!("Balance before {}", balance_before);
    // println!("Balance after {}", balance_after);


    // let mut stream = env
    //     .wss_provider
    //     .subscribe_pending_txs()
    //     .await
    //     .expect("Error while subscribing to pending transactions topic");
}

// async fn wss_show_transfer(ref env: &Env) -> Result<(), Box<dyn Error + Send + Sync + 'static>> {
//     let erc20_transfer_filter = Filter::new()
//         .from_block(env.last_block().await - 25)
//         .topic0(ValueOrArray::Value(H256::from(keccak256("Transfer(address,address,uint256)"))));
//     // .topic0(ValueOrArray::Value(H256::from(keccak256("Approval(address,address,uint256)"))));
//     let mut stream = env.wss_provider.subscribe_logs(&erc20_transfer_filter).await?;
//     while let Some(log) = stream.next().await {
//         println!(
//             "block: {:?}, tx: {:?}, token: {:?}, from: {:?}, to: {:?}, amount: {:?}",
//             log.block_number,
//             log.transaction_hash,
//             log.address,
//             Address::from(log.topics[1]),
//             Address::from(log.topics[2]),
//             U256::decode(log.data)
//         );
//     }
//     Ok(())
// }

// websocket event
async fn wss_show_swap(mut env: Env) -> Result<(), Box<dyn Error + Send + Sync + 'static>> {
    //Swap(index_topic_1 address sender, uint256 amount0In, uint256 amount1In, uint256 amount0Out, uint256 amount1Out, index_topic_2 address to)View Source
    let erc20_swap_filter = Filter::new()
        .from_block(env.last_block().await - 25)
        .topic0(ValueOrArray::Value(H256::from(keccak256("Swap(address,uint256,uint256,uint256,uint256,address)"))));
    let mut stream = env.wss_provider.subscribe_logs(&erc20_swap_filter).await?;
    while let Some(log) = stream.next().await {
        if Address::from(log.topics[1]) != env.swap_contract { continue; }
        println!(
            "{:?} ,block: {:?}, tx: {:?}, token: {:?}, sender: {:?}, to: {:?}, amount: {:?}",
            now(),
            log.block_number,
            log.transaction_hash,
            log.address,
            Address::from(log.topics[1]),
            Address::from(log.topics[2]),
            U256::decode(log.data)
        );
    }
    Ok(())
}

// get now time
fn now() -> DateTime<Local> {
    let now: DateTime<Local> = Local::now();
    let mills: i64 = now.timestamp_millis();
    let dt: DateTime<Local> = Local.timestamp_millis(mills);
    return dt;
}


fn log() {
    // tracing lib init
    // let file_appender = tracing_appender::rolling::hourly("./", "example.log");
    // let (non_blocking, _guard) = tracing_appender::non_blocking(file_appender);
    // tracing_subscriber::fmt().with_writer(non_blocking).init();
}
