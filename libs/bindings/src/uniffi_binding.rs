use study_core::binding::{HelloRequest, HelloResponse, SumRequest, SumResponse};

pub fn hello(req: HelloRequest) -> HelloResponse {
    study_core::binding::hello(req).unwrap()
}

pub fn sum(req: SumRequest) -> SumResponse {
    study_core::binding::sum(req).unwrap()
}
