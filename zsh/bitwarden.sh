KEYCHAIN="$HOME/Library/Keychains/login.keychain-db"

#####################################
# Unlock Keychain
#####################################
keychain-unlock() {
  local timeout="${1:-10}"

  if ! security show-keychain-info "$KEYCHAIN" &>/dev/null; then
    echo "→ Unlocking Keychain..."
    security unlock-keychain "$KEYCHAIN"
  fi

  security set-keychain-settings -t "$timeout" "$KEYCHAIN"

  echo "✓ Keychain unlocked for $timeout minutes."
}

#####################################
# Store a Secret
#####################################
secret-set() {
  local secret_name="$1"
  if [ -z "$secret_name" ]; then
    echo -n "Enter the secret name: "
    read secret_name
  fi

  echo -n "Enter the value for '$secret_name' (will not be displayed): "
  read -s secret_value
  echo ""

  security add-generic-password -a "$USER" -s "$secret_name" -w "$secret_value" -U 2>/dev/null

  unset secret_value

  echo "✓ Secret '$secret_name' successfully stored in the Keychain."
}

#####################################
# Retrieve a Secret
#####################################
secret-get() {
  local secret_name="$1"

  if [ -z "$secret_name" ]; then
    echo "Usage: secret-get <secret_name>"
    exit 1
  fi

  local secret_value
  secret_value=$(security find-generic-password -a "$USER" -s "$secret_name" -w 2>/dev/null)

  if [ $? -ne 0 ]; then
    echo "Keychain is locked or secret '$secret_name' not found."
    echo "Attempting to unlock the Keychain..."
    keychain-unlock
    secret_value=$(security find-generic-password -a "$USER" -s "$secret_name" -w 2>/dev/null)
    if [ $? -ne 0 ]; then
      echo "Failed to retrieve the secret '$secret_name'. It might not exist."
      exit 1
    fi
  fi

  echo "$secret_value"
}

#####################################
# Remove a Secret
#####################################
secret-remove() {
  local secret_name="$1"

  if [ -z "$secret_name" ]; then
    echo "Usage: secret-remove <secret_name>"
    exit 1
  fi

  if ! security delete-generic-password -a "$USER" -s "$secret_name" 2>/dev/null; then
    echo "Failed to remove '$secret_name'. It may not exist."
    exit 1
  fi

  echo "✓ Secret '$secret_name' removed from Keychain."
}

#####################################
# Help Function
#####################################
secret-help() {
  echo "Available commands:"
  echo "  keychain-unlock [timeout]  - Unlock keychain with optional timeout (in minutes)"
  echo "  secret-set [name]          - Store a secret"
  echo "  secret-get <name>          - Retrieve a secret"
  echo "  secret-remove <name>       - Delete a secret"
  echo "  secret-help                - Show this help"
}

#####################################
# Backup a Secret
#####################################
secret-backup() {
  local secret_name="$1"
  if [ -z "$secret_name" ]; then
    echo "Usage: secret-backup <secret_name>"
    return 1
  fi

  local value
  value=$(secret-get "$secret_name")

  local backup_dir=~/Dropbox/secrets
  mkdir -p "$backup_dir"

  echo -n "Enter a password to encrypt the backup: "
  read -s backup_password
  echo ""

  local temp_file
  temp_file=$(mktemp)

  cat >"$temp_file" <<EOF
{
  "name": "$secret_name",
  "created": "$(date)",
  "value": "$value"
}
EOF

  openssl enc -aes-256-cbc -salt -pbkdf2 -in "$temp_file" \
    -out "${backup_dir}/${secret_name}.enc" \
    -pass pass:"$backup_password"

  echo ""
  echo "===== RECOVERY INSTRUCTIONS ====="
  echo "To recover on any device:"
  echo "1. Access the file at: ${backup_dir}/${secret_name}.enc"
  echo "2. In a terminal: openssl enc -d -aes-256-cbc -pbkdf2 -in ${secret_name}.enc -pass pass:YOUR_PASSWORD"
  echo "3. Online: Use https://decrypt.tools (Algorithm: AES-256-CBC, Mode: Base64)"
  echo "===================================="

  rm "$temp_file"
}
