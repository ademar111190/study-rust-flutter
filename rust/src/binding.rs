use crate::add_from_lib;

#[no_mangle]
pub extern fn add(left: usize, right: usize) -> usize {
    add_from_lib(left, right)
}
