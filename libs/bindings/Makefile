CURRENT_DIR := $(shell pwd)
SOURCES=$(sort $(wildcard ./src/*.rs ./src/**/*.rs))
OS_NAME=$(shell uname | tr '[:upper:]' '[:lower:]')

.PHONY: init
init:
	rustup target add \
		aarch64-apple-ios \
		x86_64-apple-ios\
		aarch64-apple-darwin \
		x86_64-apple-darwin \
		aarch64-apple-ios-sim \
		aarch64-linux-android \
		armv7-linux-androideabi \
		i686-linux-android \
		x86_64-linux-android \
		aarch64-unknown-linux-gnu \
		x86_64-unknown-linux-gnu
	cargo install cargo-lipo cbindgen cargo-ndk

all: swift-ios swift-darwin bindings-swift kotlin bindings-android
apple	: swift-ios swift-darwin bindings-swift

ios-universal: $(SOURCES)
	mkdir -p ../target/ios-universal/release
	mkdir -p ../target/ios-universal-sim/release
	cargo build --release --target aarch64-apple-ios ;\
	cargo build --release --target x86_64-apple-ios ;\
	cargo build --release --target aarch64-apple-ios-sim ;\
	# build universal lib for arm device and x86 sim
	lipo -create -output ../target/ios-universal/release/libstudy_bindings.a ../target/aarch64-apple-ios/release/libstudy_bindings.a ../target/x86_64-apple-ios/release/libstudy_bindings.a
	# build universal lib for arm sim and x86 sim
	lipo -create -output ../target/ios-universal-sim/release/libstudy_bindings.a ../target/aarch64-apple-ios-sim/release/libstudy_bindings.a ../target/x86_64-apple-ios/release/libstudy_bindings.a

darwin-universal: $(SOURCES)
	mkdir -p ../target/darwin-universal/release
	cargo lipo --release --targets aarch64-apple-darwin
	cargo lipo --release --targets x86_64-apple-darwin
	lipo -create -output ../target/darwin-universal/release/libstudy_bindings.dylib ../target/aarch64-apple-darwin/release/libstudy_bindings.dylib ../target/x86_64-apple-darwin/release/libstudy_bindings.dylib
	lipo -create -output ../target/darwin-universal/release/libstudy_bindings.a ../target/aarch64-apple-darwin/release/libstudy_bindings.a ../target/x86_64-apple-darwin/release/libstudy_bindings.a

swift-ios: ios-universal
	cargo run --features=uniffi/cli --bin uniffi-bindgen generate src/study.udl -l swift -o ffi/swift-ios
	cp ../target/ios-universal/release/libstudy_bindings.a ffi/swift-ios
	cd ffi/swift-ios && "swiftc" "-emit-module" "-module-name" "study_bindings"  "-Xcc" "-fmodule-map-file=$(CURRENT_DIR)/ffi/swift-ios/studyFFI.modulemap" "-I" "."  "-L" "." "-lstudy_bindings" Study.swift

swift-darwin: darwin-universal
	cargo run --features=uniffi/cli --bin uniffi-bindgen generate src/study.udl -l swift -o ffi/swift-darwin
	cp ../target/darwin-universal/release/libstudy_bindings.dylib ffi/swift-darwin
	cd ffi/swift-darwin && "swiftc" "-emit-module" "-module-name" "study_bindings"  "-Xcc" "-fmodule-map-file=$(CURRENT_DIR)/ffi/swift-darwin/studyFFI.modulemap" "-I" "."  "-L" "." "-lstudy_bindings" Study.swift

bindings-swift: ios-universal darwin-universal
	mkdir -p bindings-swift/Sources/Study
	cargo run --features=uniffi/cli --bin uniffi-bindgen generate src/study.udl --no-format --language swift --out-dir bindings-swift/Sources/Study
	mv bindings-swift/Sources/Study/Study.swift bindings-swift/Sources/Study/Study.swift
	cp bindings-swift/Sources/Study/studyFFI.h bindings-swift/studyFFI.xcframework/ios-arm64/studyFFI.framework/Headers
	cp bindings-swift/Sources/Study/studyFFI.h bindings-swift/studyFFI.xcframework/ios-arm64_x86_64-simulator/studyFFI.framework/Headers
	cp bindings-swift/Sources/Study/studyFFI.h bindings-swift/studyFFI.xcframework/macos-arm64_x86_64/studyFFI.framework/Headers
	cp ../target/aarch64-apple-ios/release/libstudy_bindings.a bindings-swift/studyFFI.xcframework/ios-arm64/studyFFI.framework/studyFFI
	cp ../target/ios-universal-sim/release/libstudy_bindings.a bindings-swift/studyFFI.xcframework/ios-arm64_x86_64-simulator/studyFFI.framework/studyFFI
	cp ../target/darwin-universal/release/libstudy_bindings.a bindings-swift/studyFFI.xcframework/macos-arm64_x86_64/studyFFI.framework/studyFFI
	rm bindings-swift/Sources/Study/studyFFI.h
	rm bindings-swift/Sources/Study/studyFFI.modulemap

kotlin: android
	cargo run --features=uniffi/cli --bin uniffi-bindgen generate src/study.udl --language kotlin -o ffi/kotlin

android: aarch64-linux-android armv7-linux-androideabi i686-linux-android x86_64-linux-android

aarch64-linux-android: $(SOURCES) ndk-home
	cargo ndk -t aarch64-linux-android -o ffi/kotlin/jniLibs build --release
	cp -a $(ANDROID_NDK_HOME)/toolchains/llvm/prebuilt/$(OS_NAME)-x86_64/sysroot/usr/lib/aarch64-linux-android/libc++_shared.so ffi/kotlin/jniLibs/arm64-v8a/

armv7-linux-androideabi: $(SOURCES) ndk-home
	cargo ndk -t armv7-linux-androideabi -o ffi/kotlin/jniLibs build --release
	cp -a $(ANDROID_NDK_HOME)/toolchains/llvm/prebuilt/$(OS_NAME)-x86_64/sysroot/usr/lib/arm-linux-androideabi/libc++_shared.so ffi/kotlin/jniLibs/armeabi-v7a/

i686-linux-android: $(SOURCES) ndk-home
	cargo ndk -t i686-linux-android -o ffi/kotlin/jniLibs build --release
	cp -a $(ANDROID_NDK_HOME)/toolchains/llvm/prebuilt/$(OS_NAME)-x86_64/sysroot/usr/lib/i686-linux-android/libc++_shared.so ffi/kotlin/jniLibs/x86/

x86_64-linux-android: $(SOURCES) ndk-home
	cargo ndk -t x86_64-linux-android -o ffi/kotlin/jniLibs build --release
	cp -a $(ANDROID_NDK_HOME)/toolchains/llvm/prebuilt/$(OS_NAME)-x86_64/sysroot/usr/lib/x86_64-linux-android/libc++_shared.so ffi/kotlin/jniLibs/x86_64/

bindings-android: kotlin
	cp -r ffi/kotlin/jniLibs bindings-android/lib/src/main
	cp -r ffi/kotlin/study bindings-android/lib/src/main/kotlin/
	cd bindings-android && ./gradlew assemble
	mkdir -p ffi/android
	cp bindings-android/lib/build/outputs/aar/lib-release.aar ffi/android

.PHONY: ndk-home
ndk-home:
	@if [ ! -d "${ANDROID_NDK_HOME}" ] ; then \
		echo "Error: Please, set the ANDROID_NDK_HOME env variable to point to your NDK folder" ; \
		exit 1 ; \
	fi
