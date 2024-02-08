SOURCES=$(sort $(wildcard ./src/*.rs ./src/**/*.rs))

init:
	rustup target add \
		aarch64-apple-ios \
		x86_64-apple-ios \
		aarch64-apple-ios-sim \
		aarch64-apple-darwin \
		x86_64-apple-darwin \
		aarch64-linux-android \
		armv7-linux-androideabi \
		i686-linux-android \
		x86_64-linux-android
	cargo install \
		cargo-lipo \
		cbindgen \
		cargo-ndk

all: ios macos android
apple: ios macos

ios: $(SOURCES)
	cargo lipo --release

target/x86_64-apple-ios/debug/libstudy.a: $(SOURCES)
	cargo lipo --targets x86_64-apple-ios
	cp target/x86_64-apple-ios/debug/libstudy.a ../ios/libstudy.a

target/aarch64-apple-ios-sim/debug/libstudy.a: $(SOURCES)
	cargo lipo --targets aarch64-apple-ios-sim
	cp target/aarch64-apple-ios-sim/debug/libstudy.a ../ios/libstudy.a

macos: x86_64-apple-darwin aarch64-apple-darwin

x86_64-apple-darwin: $(SOURCES)
	cargo lipo --release --targets x86_64-apple-darwin

aarch64-apple-darwin: $(SOURCES)
	cargo lipo --release --targets aarch64-apple-darwin

android: armv7-linux-androideabi aarch64-linux-android i686-linux-android x86_64-linux-android

armv7-linux-androideabi: $(SOURCES) ndk-home
	cargo ndk -t armv7-linux-androideabi build --release

aarch64-linux-android: $(SOURCES) ndk-home
	cargo ndk -t aarch64-linux-android build --release

i686-linux-android: $(SOURCES) ndk-home
	cargo ndk -t i686-linux-android build --release

x86_64-linux-android: $(SOURCES) ndk-home
	cargo ndk -t x86_64-linux-android build --release

ndk-home:
	@if [ ! -d "${ANDROID_NDK_HOME}" ] ; then \
		echo "Error: Please, set the ANDROID_NDK_HOME env variable to point to your NDK folder" ; \
		exit 1 ; \
	fi
