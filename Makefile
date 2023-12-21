
build: definitions
	go build -buildmode=c-shared -o functions.so
	@make clean >/dev/null 2>&1

definitions: clean
	@/usr/bin/env bash -c "for i in \$$(find . -name '*.go' ! -name pg_cgo.go -exec grep func {} \; | awk '{print \$$2}' | cut -d '(' -f 1 | grep -E '^[A-Z]'); do echo \"PG_FUNCTION_INFO_V1(\$$i);\";done >> definitions"
	@[ -f definitions ] && awk '/\/\/ START OF PGFUNC/ {print; while (getline < "definitions") print; f=1; next} f && /\/\/ END OF PGFUNC/ {print; f=0; next} !f' pg_cgo.go > pg_cgo-modified.go && mv pg_cgo-modified.go pg_cgo.go || exit 1

clean:
	@rm -f definitions pg_cgo-modified.go functions.h
