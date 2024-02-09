SOURCES=$(sort $(wildcard ../core/src/*.rs ../core/src/**/*.rs))
SHELL := /bin/bash
OS_NAME=$(shell uname | tr '[:upper:]' '[:lower:]')

.PHONY: init
init:
	cargo install cargo-ndk cargo-expand
	cargo install flutter_rust_bridge_codegen --version 1.82.6
	flutter pub get

all: ios android

flutter_rust_bridge:
	flutter_rust_bridge_codegen --dart-format-line-length 110 -r ../core/src/binding.rs -d lib/bridge_generated.dart -c ios/Classes/bridge_generated.h

ios: $(SOURCES) flutter_rust_bridge
	make -C ../bindings bindings-swift
	rm -rf ios/bindings-swift
	cp -r ../bindings/bindings-swift ios/bindings-swift
	rm -rf ios/bindings-swift/Tests
	rm -f ios/bindings-swift/Package.swift

.PHONY: android
android: $(SOURCES) flutter_rust_bridge
	make -C ../bindings kotlin
	mkdir -p ./android/src/main/jniLibs
	cp -r ../bindings/ffi/kotlin/jniLibs/* ./android/src/main/jniLibs
	mkdir -p ./android/src/main/kotlin/study/
	cp -r ../bindings/ffi/kotlin/study/* ./android/src/main/kotlin/study/
