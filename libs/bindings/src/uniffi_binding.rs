use once_cell::sync::Lazy;
use study_core::binding::{HelloRequest, HelloResponse, SumRequest, SumResponse};
use tokio::runtime::Runtime;

static RT: Lazy<Runtime> = Lazy::new(|| Runtime::new().unwrap());

fn rt() -> &'static Runtime {
    &RT
}

pub fn hello(req: HelloRequest) -> HelloResponse {
    rt().block_on(study_core::binding::hello(req)).unwrap()
}

pub fn sum(req: SumRequest) -> SumResponse {
    rt().block_on(study_core::binding::sum(req)).unwrap()
}
