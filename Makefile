.goals = build-web deploy serve release
.PHONY : build-web deploy serve release

build-web :
	cp $$GOROOT/misc/wasm/wasm_exec.js web/assets/
	GOOS=js GOARCH=wasm go build -o web/assets/jd.wasm ./web/ui/main.go

pack-web : build-web
	go run web/pack/main.go

deploy : build-web
	gsutil -m cp -r web/assets/* gs://play.jd-tool.io

serve : pack-web
	go run main.go -port 8080

release : pack-web
	mkdir -p release
	go build -o release/jd main.go
