# Stage 1: Build environment
FROM rust:1.75-slim as builder
WORKDIR /usr/src/app

# Copy the source code
COPY . .

# Build the application in release mode
RUN cargo build --release

# Stage 2: Runtime environment
FROM debian:bookworm-slim
WORKDIR /app

# Install any necessary runtime dependencies (e.g., certificates for network requests)
RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*

# Copy the compiled binary from the builder stage
# IMPORTANT: Replace "YOUR_APP_NAME" with the actual package name from your Cargo.toml
COPY --from=builder /usr/src/app/target/release/YOUR_APP_NAME ./

# Run the binary
CMD ["./YOUR_APP_NAME"]
