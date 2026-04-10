#!/usr/bin/env bash
# Sample job script with intentional RRFS norm violations for testing.
# This file exercises every rule

# --- RRFS001: dot-source ---
. /etc/profile

# --- RRFS002: single bracket ---
if [ -d /tmp ]; then
  echo "exists"
fi

# --- RRFS003: single = in [[ ]] ---
if [[ ${FOO} = bar ]]; then
  echo "match"
fi

# --- RRFS004: -f instead of -s ---
if [[ -f /tmp/input.dat ]]; then
  echo "file found"
fi

# --- RRFS005: date arithmetic ---
PREV_DATE=$(date -d "yesterday" +%Y%m%d)

# --- RRFS006: TAB indentation ---
	echo "indented with tab"

# --- RRFS007: lowercase exported var ---
export my_var="hello"

# --- RRFS008: missing dash in default ---
OUTPUT=${OUTDIR:"default_path"}

# --- RRFS009: $var without braces ---
echo $HOME $USER

# --- RRFS010: arithmetic in [[ ]] ---
if [[ ${count} -eq 5 ]]; then
  echo "five"
fi

# --- RRFS011: unquoted -z test ---
if [[ -z ${cycles} ]]; then
  echo "empty"
fi

# --- RRFS014: backticks ---
HOSTNAME=`hostname`

# --- RRFS015: quoted boolean ---
DO_JEDI="true"
RUN_SMOKE="false"

# --- RRFS016: compare without ^^ ---
if [[ ${DO_JEDI} == "TRUE" ]]; then
  echo "jedi on"
fi

# --- RRFS017: non-standard variable names ---
YYYYMMDD=20250101
HH=12
CDATE_VAL=${YYYYMMDDHH}

# --- RRFS018: python invocation ---
python run_post.py
python script.py --arg1
