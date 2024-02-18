#!/usr/bin/make -f

build:
	go build -mod=readonly -o build/merlind ./cmd/merlind
