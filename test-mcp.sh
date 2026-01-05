#!/bin/bash
# MCP Tool Call Test Script - Read responses from SSE stream

echo "=== MCP Server Tool Call Test ==="
echo ""

# Create temp files
SSE_OUTPUT=$(mktemp)
trap "rm -f $SSE_OUTPUT; kill $SSE_PID 2>/dev/null" EXIT

# Step 1: Start SSE connection in background and capture output
echo "1. Starting SSE connection in background..."
curl -s -N http://localhost:8080/sse > "$SSE_OUTPUT" 2>/dev/null &
SSE_PID=$!

# Wait for session response
sleep 1

# Read first two lines for session info
SESSION_RESPONSE=$(head -2 "$SSE_OUTPUT")
echo "SSE Response: $SESSION_RESPONSE"

SESSION_ID=$(echo "$SESSION_RESPONSE" | grep data: | sed 's/data:\/mcp\/message?sessionId=//')
echo "Session ID: $SESSION_ID"
echo ""

if [ -z "$SESSION_ID" ]; then
    echo "ERROR: Failed to get session ID. Is the server running?"
    exit 1
fi

MESSAGE_URL="http://localhost:8080/mcp/message?sessionId=$SESSION_ID"

# Function to wait for SSE response
wait_for_response() {
    sleep 0.5
    # Get the latest lines from SSE output (skip first 2 header lines)
    tail -n +3 "$SSE_OUTPUT" | tail -20
}

# Step 2: Initialize MCP
echo "2. Sending initialize request..."
curl -s -X POST "$MESSAGE_URL" \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"test-client","version":"1.0"}}}'
echo "Waiting for SSE response..."
sleep 1
echo "Initialize Response from SSE:"
tail -n +3 "$SSE_OUTPUT" | head -10
echo ""

# Step 3: Send initialized notification
echo "3. Sending initialized notification..."
curl -s -X POST "$MESSAGE_URL" \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"notifications/initialized"}'
sleep 0.5
echo ""

# Step 4: List tools
echo "4. Listing available tools..."
BEFORE_LINES=$(wc -l < "$SSE_OUTPUT")
curl -s -X POST "$MESSAGE_URL" \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","id":2,"method":"tools/list"}'
sleep 1
echo "Tools List Response from SSE:"
tail -n +$((BEFORE_LINES + 1)) "$SSE_OUTPUT" | head -20
echo ""

# Step 5: Call getCurrentTime tool
echo "5. Calling getCurrentTime tool..."
BEFORE_LINES=$(wc -l < "$SSE_OUTPUT")
curl -s -X POST "$MESSAGE_URL" \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","id":3,"method":"tools/call","params":{"name":"getCurrentTime","arguments":{}}}'
sleep 1
echo "getCurrentTime Response from SSE:"
tail -n +$((BEFORE_LINES + 1)) "$SSE_OUTPUT" | head -10
echo ""

# Step 6: Call add tool
echo "6. Calling add tool (5 + 3)..."
BEFORE_LINES=$(wc -l < "$SSE_OUTPUT")
curl -s -X POST "$MESSAGE_URL" \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","id":4,"method":"tools/call","params":{"name":"add","arguments":{"a":5,"b":3}}}'
sleep 1
echo "Add Response from SSE:"
tail -n +$((BEFORE_LINES + 1)) "$SSE_OUTPUT" | head -10
echo ""

echo "=== Full SSE Output ==="
cat "$SSE_OUTPUT"
echo ""
echo "=== Test Complete ==="
