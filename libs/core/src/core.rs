use std::sync::Arc;

pub(crate) struct Core {
    pub(crate) api: Arc<dyn Api>,
}

pub(crate) trait Api: Send + Sync {
    fn hello(&self, name: String) -> String;
    fn sum(&self, lhs: i32, rhs: i32) -> i32;
}

pub(crate) struct ApiImpl;

impl Api for ApiImpl {
    fn hello(&self, name: String) -> String {
        format!("Hello, {}!", name)
    }

    fn sum(&self, lhs: i32, rhs: i32) -> i32 {
        lhs + rhs
    }
}

#[cfg(test)]
mod tests {
    use std::sync::Arc;
    use crate::core::{ApiImpl, Core};

    #[test]
    fn test_hello() {
        let core = Core {
            api: Arc::new(ApiImpl {}),
        };
        assert_eq!(core.api.hello("world".to_string()), "Hello, world!");
    }

    #[test]
    fn test_sum() {
        let core = Core {
            api: Arc::new(ApiImpl {}),
        };
        assert_eq!(core.api.sum(1, 2), 3);
    }
}
