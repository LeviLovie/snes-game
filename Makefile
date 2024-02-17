.PHONY: build

build:
	@mkdir -p out
	@ca65 ./src/main.asm -o ./out/main.o -g
	@ld65 -C ./src/lorom.cfg -o ./out/main.sfc ./out/main.o

run_emu:
	~/.mesen/bin/osx-arm64/Release/Mesen
