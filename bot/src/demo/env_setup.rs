,
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