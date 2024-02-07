mod binding;

pub fn add_from_lib(left: usize, right: usize) -> usize {
    left + right
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn it_works() {
        let result = add_from_lib(2, 2);
        assert_eq!(result, 4);
    }
}
