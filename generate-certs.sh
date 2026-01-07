#!/bin/bash

# Directory for certificates
CERT_DIR="./certs"

if [ ! -d "$CERT_DIR" ]; then
  mkdir -p "$CERT_DIR"
  echo "Created certs directory."
fi

# Check if certs already exist
if [ -f "$CERT_DIR/server.crt" ] && [ -f "$CERT_DIR/server.key" ]; then
  echo "Certificates already exist in $CERT_DIR. Skipping generation."
  exit 0
fi

echo "Generating self-signed certificate for localhost..."

major_version=$(openssl version | awk '{print $2}' | cut -d. -f1)

if [ "$major_version" == "1" ]; then
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout "$CERT_DIR/privkey.pem" \
    -out "$CERT_DIR/fullchain.pem" \
    -subj "/C=US/ST=State/L=City/O=Organization/CN=localhost"
    echo "Certificates generated successfully (OpenSSL 1.x)."
else 
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout "$CERT_DIR/privkey.pem" \
    -out "$CERT_DIR/fullchain.pem" \
    -subj "/C=US/ST=State/L=City/O=Organization/CN=localhost" \
    -addext "subjectAltName=DNS:localhost"
    echo "Certificates generated successfully (OpenSSL 3.x with SAN)."
fi

chmod 644 "$CERT_DIR/fullchain.pem"
chmod 600 "$CERT_DIR/privkey.pem"
