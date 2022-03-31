#!/usr/bin/env bash
go mod vendor
go install -a -ldflags "-extldflags '-static'" github.com/gmarkey/CPU-Pooler/cmd/fakelscpu
rm -rf /usr/bin/lscpu
cp ${GOPATH}/bin/fakelscpu /usr/bin/lscpu
go test -v github.com/gmarkey/CPU-Pooler/test/...
