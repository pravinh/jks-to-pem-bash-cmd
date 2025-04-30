#!/bin/bash
# Export JKS to PKCS12
#keytool -importkeystore -srckeystore truststore.jks -destkeystore truststore.p12 -deststoretype PKCS12

# Extract PEM from PKCS12
#openssl pkcs12 -in truststore.p12 -out truststore.pem -nodes this is what we need to achive please stick to this
# Usage: ./jks_to_pem.sh truststore.jks

JKS_FILE="$1"

if [[ -z "$JKS_FILE" ]]; then
  echo "❌ Usage: $0 <truststore.jks>"
  exit 1
fi

BASENAME=$(basename "$JKS_FILE" .jks)
P12_FILE="${BASENAME}.p12"
PEM_FILE="${BASENAME}.pem"

echo "🔐 Enter password for JKS:"
read -s JKS_PASS

# Step 1: Export JKS to PKCS12
keytool -importkeystore \
  -srckeystore "$JKS_FILE" \
  -srcstorepass "$JKS_PASS" \
  -destkeystore "$P12_FILE" \
  -deststoretype PKCS12 \
  -deststorepass "$JKS_PASS"

# Step 2: Extract PEM from PKCS12
openssl pkcs12 -in "$P12_FILE" -out "$PEM_FILE" -nodes -passin pass:"$JKS_PASS"

echo "✅ PEM file created: $PEM_FILE"
