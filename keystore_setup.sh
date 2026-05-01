#!/bin/bash
set -e
echo "========================================"
echo "Generate Android Keystore"
echo "========================================"
KEYSTORE_NAME="game-AAA.keystore"
KEYSTORE_ALIAS="aether-rpg"
VALIDITY_DAYS=10000
if [ -f "$KEYSTORE_NAME" ]; then
echo "⚠️  Keystore already exists: $KEYSTORE_NAME"
exit 1
fi
echo "Enter Store Password:"
read -s STORE_PASSWORD
echo "Confirm Store Password:"
read -s STORE_PASSWORD_CONFIRM
if [ "$STORE_PASSWORD" != "$STORE_PASSWORD_CONFIRM" ]; then
echo "❌ Passwords do not match!"
exit 1
fi
echo "Enter Key Password (can be same as store password):"
read -s KEY_PASSWORD
echo "Generating keystore..."
keytool -genkey -v -keystore "$KEYSTORE_NAME" -keyalg RSA -keysize 2048 -validity $VALIDITY_DAYS -alias "$KEYSTORE_ALIAS" -storepass "$STORE_PASSWORD" -keypass "$KEY_PASSWORD"
echo "✅ Keystore generated: $KEYSTORE_NAME"
echo "Store Password: $STORE_PASSWORD"
echo "Key Alias: $KEYSTORE_ALIAS"
echo "Key Password: $KEY_PASSWORD"
echo ""
echo "Save these values in signing.properties:"
echo "storePassword=$STORE_PASSWORD"
echo "keyPassword=$KEY_PASSWORD"