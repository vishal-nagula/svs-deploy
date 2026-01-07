#!/bin/bash

if [ ! -f .env ]; then
  echo "Error: .env file not found. Please cp .env.example .env and configure it."
  exit 1
fi

echo "Deploying SVS..."
docker compose up -d --build
