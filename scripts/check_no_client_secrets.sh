#!/usr/bin/env bash
# Fails (exit 1) if the Flutter client could ship an Anthropic/OpenAI secret.
# Run from the repo root BEFORE every `flutter build appbundle`.
set -u
fail=0

echo "1) .env must not be a Flutter asset"
if grep -nE '^\s*-\s*\.env' pubspec.yaml; then echo "   FAIL"; fail=1; else echo "   ok"; fi

echo "2) No API-key material in client code (lib/, assets/, android/, ios/)"
if grep -rnE 'sk-ant-[A-Za-z0-9_-]{10,}|sk-[A-Za-z0-9]{32,}' lib assets android ios 2>/dev/null; then
  echo "   FAIL: key-like string found"; fail=1; else echo "   ok"; fi

echo "3) Client must not read ANTHROPIC_/OPENAI_ keys from dotenv"
if grep -rnE "dotenv\.env\[['\"](ANTHROPIC|OPENAI)_API_KEY" lib 2>/dev/null; then
  echo "   FAIL"; fail=1; else echo "   ok"; fi

echo "4) Client must not call api.anthropic.com / api.openai.com directly"
if grep -rnE 'api\.(anthropic|openai)\.com' lib 2>/dev/null; then
  echo "   FAIL"; fail=1; else echo "   ok"; fi

echo "5) No x-api-key header in client code"
if grep -rn "x-api-key" lib 2>/dev/null; then echo "   FAIL"; fail=1; else echo "   ok"; fi

echo "6) .env files must be git-ignored"
if [ -f .gitignore ] && grep -qE '^\.env' .gitignore; then echo "   ok"; else echo "   FAIL: add .env to .gitignore"; fail=1; fi

exit $fail