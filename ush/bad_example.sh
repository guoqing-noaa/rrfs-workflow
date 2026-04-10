#!/usr/bin/env bash
# Sample job script with intentional RRFS norm violations for testing.
# --- RRFS001: dot-source ---
. /etc/profile

# --- RRFS002: single bracket ---
if [ -d /tmp ]; then
  echo "exists"
fi
