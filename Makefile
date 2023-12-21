
build: definitions
	go build -buildmode=c-shared -o libplgo.so
	@make clean >/dev/null 2>&1

definitions: clean
	@/usr/bin/env bash -c "for i in \$$(find . -name '*.go' ! -name pg_cgo_helper.go -exec grep '//export ' {} \; | awk '{print \$$2}'); do echo \"PG_FUNCTION_INFO_V1(\$$i);\";done >> definitions"
	@[ -f definitions ] && awk '/\/\/ START OF PGFUNC/ {print; while (getline < "definitions") print; f=1; next} f && /\/\/ END OF PGFUNC/ {print; f=0; next} !f' pg_cgo_helper.go > pg_cgo_helper-modified.go && mv pg_cgo_helper-modified.go pg_cgo_helper.go || exit 1

clean:
	@rm -f definitions pg_cgo_helper-modified.go libplgo.h
