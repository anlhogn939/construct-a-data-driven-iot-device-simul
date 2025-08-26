#!/bin/bash

# API Specification for Data-Driven IoT Device Simulator

# Device Configuration
DEVICE_ID="DEV-001"
DEVICE_TYPE=" Temperature Sensor"

# API Endpoints
BASE_URL="http://localhost:8080/api"
DEVICE_ENDPOINT="${BASE_URL}/devices/${DEVICE_ID}"
SENSOR_ENDPOINT="${DEVICE_ENDPOINT}/sensors"

# Sensor Data Structure
SENSOR_DATA=$(cat <<EOF
{
  "temperature": 25.5,
  "humidity": 60,
  "timestamp": "$(date +%s)"
}
EOF
)

# Simulate Sensor Data Generation
simulate_sensor_data() {
  while true; do
    # Generate Random Sensor Data
    temperature=$(awk 'BEGIN{srand();print srand()*10+20}')
    humidity=$(awk 'BEGIN{srand();print srand()*10+50}')
    timestamp=$(date +%s)
    SENSOR_DATA=$(jq -n --arg temperature "$temperature" --arg humidity "$humidity" --arg timestamp "$timestamp" '{temperature: $temperature, humidity: $humidity, timestamp: $timestamp}')
    # Send Sensor Data to API
    curl -X POST \
      ${SENSOR_ENDPOINT} \
      -H 'Content-Type: application/json' \
      -d "${SENSOR_DATA}"
    sleep 10
  done
}

# Start Simulator
simulate_sensor_data