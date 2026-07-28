.PHONY: run run-docker

# Auto-detect platform and run the native pre-compiled binary
# Support passing SRC to autoload a directory, e.g.: make run SRC=/path/to/project
run:
	@chmod +x ./znt* 2>/dev/null || true
	@if [ "$$(uname -s)" = "Darwin" ]; then \
		if [ "$$(uname -m)" = "arm64" ]; then \
			echo "Running macOS Apple Silicon version..."; \
			./znt-darwin-arm64 $(if $(SRC),-autoload-path $(SRC),); \
		else \
			echo "Running macOS Intel version..."; \
			./znt-darwin-amd64 $(if $(SRC),-autoload-path $(SRC),); \
		fi; \
	elif [ "$$(uname -s)" = "Linux" ]; then \
		if [ "$$(uname -m)" = "aarch64" ] || [ "$$(uname -m)" = "arm64" ]; then \
			echo "Running Linux ARM64 version..."; \
			./znt-linux-arm64 $(if $(SRC),-autoload-path $(SRC),); \
		else \
			echo "Running Linux AMD64 version..."; \
			./znt-linux-amd64 $(if $(SRC),-autoload-path $(SRC),); \
		fi; \
	else \
		echo "Please run znt-windows-amd64.exe manually on Windows."; \
	fi

# Build and run a lightweight Docker container using the pre-compiled files
# Support passing SRC to automatically mount and scan a project, e.g.: make run-docker SRC=/path/to/project
run-docker:
	docker build -t znt-app:latest .
	docker run -it --rm -p 8080:8080 \
		-v $$(pwd)/config.yaml:/app/config.yaml \
		-v $$(pwd)/.znt:/app/.znt \
		$(if $(SRC),-v $(SRC):/workspace,) \
		znt-app:latest $(if $(SRC),-autoload-path /workspace,)
