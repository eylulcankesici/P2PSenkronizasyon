.PHONY: proto build run clean test

# Proto dosyalarını derle
proto:
	@echo "Generating gRPC code..."
	protoc -I. -Ithird_party --go_out=. --go_opt=paths=source_relative \
		--go-grpc_out=. --go-grpc_opt=paths=source_relative \
		api/proto/*.proto

# Uygulamayı derle
build:
	@echo "Building Aether..."
	go build -o bin/aether-server.exe cmd/aether-server/main.go

# Uygulamayı çalıştır
run:
	@echo "Running Aether..."
	go run cmd/aether-server/main.go

# Hot reload ile çalıştır (air kullanarak)
dev:
	air

# Test çalıştır
test:
	go test -v -race -coverprofile=coverage.out ./...

# Coverage raporunu göster
coverage:
	go tool cover -html=coverage.out

# Temizlik
clean:
	@echo "Cleaning..."
	rm -rf bin/
	rm -f *.db
	rm -f *.log
	rm -f coverage.out

# Bağımlılıkları indir
deps:
	go mod download
	go mod tidy

# Linter çalıştır
lint:
	golangci-lint run




