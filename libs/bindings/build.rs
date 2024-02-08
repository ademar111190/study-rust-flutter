use anyhow::*;

fn main() -> Result<()> {
    uniffi_build::generate_scaffolding("./src/study.udl").unwrap();
    Ok(())
}
