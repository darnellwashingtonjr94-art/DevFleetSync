# Stage 1: Build environment
FROM rust:slim as builder
WORKDIR /usr/src/app

# Install system dependencies required to compile OpenSSL
RUN apt-get update && apt-get install -y pkg-config libssl-dev

# Copy the source code
COPY . .

# Build the application in release mode
RUN cargo build --release

# Stage 2: Runtime environment
FROM debian:bookworm-slim
WORKDIR /app

# Install runtime dependencies
RUN apt-get update && apt-get install -y ca-certificates libssl3 && rm -rf /var/lib/apt/lists/*

# Copy the compiled binary from the builder stage
COPY --from=builder /usr/src/app/target/release/DevFleetSync ./

# Run the binary
CMD ["./DevFleetSync"]
