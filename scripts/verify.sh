#!/usr/bin/env bash
set -euo pipefail

: "${LOCALSTACK_ENDPOINT:=http://localhost:4566}"
: "${AWS_DEFAULT_REGION:=eu-west-1}"

echo "==> Verificando recursos…"

# S3
BUCKET_NAME="la-huella-uploads"
if awslocal --endpoint-url="$LOCALSTACK_ENDPOINT" s3 ls "s3://$BUCKET_NAME" --region "$AWS_DEFAULT_REGION" > /dev/null 2>&1; then
  echo "[OK] S3 bucket $BUCKET_NAME existe"
else
  echo "[FAIL] S3 bucket $BUCKET_NAME NO existe"
  exit 1
fi

# DynamoDB
TABLE_NAME="la-huella-comments"
if [[ "$(awslocal --endpoint-url="$LOCALSTACK_ENDPOINT" dynamodb describe-table --table-name "$TABLE_NAME" --region "$AWS_DEFAULT_REGION" --query 'Table.TableName' --output text 2>/dev/null || echo 'NOT_FOUND')" != "NOT_FOUND" ]]; then
  echo "[OK] DynamoDB tabla $TABLE_NAME existe"
else
  echo "[FAIL] DynamoDB tabla $TABLE_NAME NO existe"
  exit 1
fi

# SQS
QUEUE_NAME="la-huella-processing-queue"
if awslocal --endpoint-url="$LOCALSTACK_ENDPOINT" sqs get-queue-url --queue-name "$QUEUE_NAME" --region "$AWS_DEFAULT_REGION" --query 'QueueUrl' --output text 2>/dev/null | grep -q "$QUEUE_NAME"; then
  echo "[OK] SQS cola $QUEUE_NAME existe"
else
  echo "[FAIL] SQS cola $QUEUE_NAME NO existe"
  exit 1
fi

echo "==> Verificación completada con éxito."
