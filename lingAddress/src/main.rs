use std::sync::Arc;
use std::sync::atomic::{AtomicBool, Ordering};
use std::thread;

use clap::Parser;
use ethers::core::rand;
use ethers::signers::{LocalWallet, Signer};
use ethers::utils::hex;

/// eth靓号生成器
#[derive(Parser, Debug)]
#[command(author, bin_name = "lingAddress", version, about, long_about = None)]
struct Args {
    /// 靓号前缀，请使用0x开始
    #[arg(short, long)]
    prefix: String,
    /// 线程数量
    #[arg(short, long, default_value_t = 2)]
    threads: u8,
}

fn main() {
    let args = Args::parse();
    // 去掉文本末尾的换行符
    let input = args.prefix.trim();
    // 定义需要执行的线程数量
    let thread_count = args.threads;

    // 定义一个原子变量，用于保存程序的运行状态
    let running = Arc::new(AtomicBool::new(true));

    // 线程管理器
    let mut threads = vec![];

    // 在新线程中注册回调函数，用于处理CTRL-C信号
    let r = running.clone();
    threads.push(thread::spawn(move || {
        ctrlc::set_handler(move || {
            r.store(false, Ordering::SeqCst);
        }).expect("Error setting Ctrl-C handler");
    }));

    // 打印文本
    println!("You  prefix: {}", input);
    println!("Find thread_count: {}", thread_count);

    // 创建新的线程,用于计算靓号
    for _ in 0..thread_count {
        let r = running.clone();
        let prefix = input.to_string();
        threads.push(thread::spawn(move || {
            // 在线程中执行主要逻辑
            while r.load(Ordering::SeqCst) {
                let wallet = LocalWallet::new(&mut rand::thread_rng());
                // println!("address :{:?}", wallet.address().to_string());
                if wallet.address().to_string().starts_with(&prefix) {
                    println!("private key:{:?}", hex::encode(wallet.signer().to_bytes()));
                    r.store(false, Ordering::SeqCst);
                    break;
                }
            }
        }));
    }
    // 阻塞主线程，等待其他线程运行完成
    for t in threads {
        t.join().expect("Failed to join thread");
    }
}
