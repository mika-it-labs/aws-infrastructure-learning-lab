#!/bin/bash
# 配置されたPythonコードを確認する。HTTP疎通検査ではない。
set -euo pipefail
cd /opt/aws-learning-ci-ec2
export PYTHONDONTWRITEBYTECODE=1
python3 -m unittest discover -s tests -v
result="$(python3 app.py)"
if [[ "$result" != "5" ]]; then
  printf '%s\n' 'Unexpected application output' >&2
  exit 1
fi
printf '%s\n' 'Validation passed'
