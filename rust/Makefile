SOURCES=$(sort $(wildcard ./src/*.rs ./src/**/*.rs))

setup:
	rustup target add \
		aarch64-apple-ios \
		x86_64-apple-ios \
		aarch64-apple-darwin \
		x86_64-apple-darwin \
		aarch64-apple-ios-sim \
		aarch64-linux-android \
		armv7-linux-androideabi \
		i686-linux-android \
		x86_64-linux-android \
		aarch64-unknown-linux-gnu \
		armv7-unknown-linux-gnueabi \
		i686-unknown-linux-gnu \
		x86_64-unknown-linux-gnu
	cargo install cargo-lipo
	cargo install cbindgen
	cargo install cargo-ndk

build: ios macos android headers

headers: target/bindings.h

target/bindings.h: src/binding.rs
	cbindgen $^ -c cbindgen.toml | grep -v \#include | uniq > $@
	@echo "[DONE] $@"

ios: ios-universal

ios-universal: $(SOURCES) ndk-home
	cargo lipo --release
	@echo "[DONE] $@"

target/x86_64-apple-ios/debug/libbreez-sdk.a: $(SOURCES) ndk-home
	@if [ $$(uname) == "Darwin" ] ; then \
		cargo lipo --targets x86_64-apple-ios; \
		cp target/x86_64-apple-ios/debug/libbreez-sdk.a ../ios/libbreez-sdk.a ; \
		else echo "Skipping iOS compilation on $$(uname)" ; \
	fi
	@echo "[DONE] $@"

target/aarch64-apple-ios-sim/debug/libbreez-sdk.a: $(SOURCES) ndk-home
	@if [ $$(uname) == "Darwin" ] ; then \
		cargo lipo --targets aarch64-apple-ios-sim; \
		cp target/aarch64-apple-ios-sim/debug/libbreez-sdk.a ../ios/libbreez-sdk.a ; \
		else echo "Skipping iOS compilation on $$(uname)" ; \
	fi
	@echo "[DONE] $@"

## macos: Compile the macOS libraries
macos: x86_64-apple-darwin aarch64-apple-darwin

x86_64-apple-darwin: $(SOURCES)
	@if [ $$(uname) == "Darwin" ] ; then \
		cargo lipo --release --targets x86_64-apple-darwin ; \
		else echo "Skipping macOS compilation on $$(uname)" ; \
	fi
	@echo "[DONE] $@"

aarch64-apple-darwin: $(SOURCES)
	@if [ $$(uname) == "Darwin" ] ; then \
		cargo lipo --release --targets aarch64-apple-darwin ; \
		else echo "Skipping macOS compilation on $$(uname)" ; \
	fi
	@echo "[DONE] $@"

android: armv7-linux-androideabi aarch64-linux-android i686-linux-android x86_64-linux-android

armv7-linux-androideabi: $(SOURCES) ndk-home
	cargo ndk -t armv7-linux-androideabi build --release

aarch64-linux-android: $(SOURCES) ndk-home
	cargo ndk -t aarch64-linux-android build --release

i686-linux-android: $(SOURCES) ndk-home
	cargo ndk -t i686-linux-android build --release

x86_64-linux-android: $(SOURCES) ndk-home
	cargo ndk -t x86_64-linux-android build --release

.PHONY: ndk-home
ndk-home:
	@if [ ! -d "${ANDROID_NDK_HOME}" ] ; then \
		echo "Error: Please, set the ANDROID_NDK_HOME env variable to point to your NDK folder" ; \
		exit 1 ; \
	fi
