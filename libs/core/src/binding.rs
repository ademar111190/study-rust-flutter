use std::sync::Arc;
use anyhow::Result;
use once_cell::sync::Lazy;
use crate::core::{Core, ApiImpl};
pub use crate::grpc::{HelloRequest, HelloResponse, SumRequest, SumResponse};

static CORE: Lazy<Arc<Core>> = Lazy::new(|| {
    Arc::new(Core {
        api: Arc::new(ApiImpl {}),
    })
});

pub fn hello(req: HelloRequest) -> Result<HelloResponse> {
    let message = CORE.api.hello(req.world);
    Ok(HelloResponse {
        message,
    })
}

pub fn sum(req: SumRequest) -> Result<SumResponse> {
    let result = CORE.api.sum(req.lhs, req.rhs);
    Ok(SumResponse {
        result,
    })
}
