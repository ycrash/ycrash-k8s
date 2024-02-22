#!/bin/bash

# Check if container_id argument is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <container_id>"
  exit 1
fi

# Assign the provided container_id to a variable
container_id="$1"

# 1. Download the yCrash agent
curl -fsSL https://tier1app.com/dist/ycrash/yc-agent-latest.zip -o yc-agent-latest.zip

# 2. Create yCrash folder
docker exec "${container_id}" mkdir -p /opt/workspace/yc-agent

# 3. Copy agent into the Docker image
docker cp yc-agent-latest.zip "${container_id}:/opt/workspace/yc-agent"

# 4. Unzip the yCrash agent
docker exec "${container_id}" unzip /opt/workspace/yc-agent/yc-agent-latest.zip -d /opt/workspace/yc-agent

# 5. Changing the YC agent permissions (if needed)
docker exec "${container_id}" chmod +rx /opt/workspace/yc-agent/linux/yc

# Cleanup: Remove the downloaded zip file
rm yc-agent-latest.zip
