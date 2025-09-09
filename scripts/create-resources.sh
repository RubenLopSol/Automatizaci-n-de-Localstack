#!/usr/bin/env bash
set -euo pipefail

: "${LOCALSTACK_ENDPOINT:=http://localhost:4566}"
: "${AWS_DEFAULT_REGION:=eu-west-1}"

echo "==> Endpoint: $LOCALSTACK_ENDPOINT | Region: $AWS_DEFAULT_REGION"
echo "==> Creando recursos en Localstack…"

# S3
BUCKET_NAME="la-huella-uploads"
echo "[S3] Creando bucket s3://$BUCKET_NAME"
awslocal --endpoint-url="$LOCALSTACK_ENDPOINT" s3 mb "s3://$BUCKET_NAME" --region "$AWS_DEFAULT_REGION" || true
awslocal --endpoint-url="$LOCALSTACK_ENDPOINT" s3 ls

# DynamoDB
TABLE_NAME="la-huella-comments"
echo "[DynamoDB] Creando tabla $TABLE_NAME"
awslocal --endpoint-url="$LOCALSTACK_ENDPOINT" dynamodb create-table \
  --table-name "$TABLE_NAME" \
  --attribute-definitions AttributeName=comment_id,AttributeType=S \
  --key-schema AttributeName=comment_id,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region "$AWS_DEFAULT_REGION" || true

awslocal --endpoint-url="$LOCALSTACK_ENDPOINT" dynamodb describe-table \
  --table-name "$TABLE_NAME" --region "$AWS_DEFAULT_REGION" \
  --query 'Table.TableName'

# SQS
QUEUE_NAME="la-huella-processing-queue"
echo "[SQS] Creando cola $QUEUE_NAME"
awslocal --endpoint-url="$LOCALSTACK_ENDPOINT" sqs create-queue \
  --queue-name "$QUEUE_NAME" --region "$AWS_DEFAULT_REGION" || true

awslocal --endpoint-url="$LOCALSTACK_ENDPOINT" sqs list-queues --region "$AWS_DEFAULT_REGION" || true

# CloudWatch Logs (opcional, si tu reto lo pide)
LOG_GROUP="/aws/la-huella/app"
echo "[Logs] Creando Log Group $LOG_GROUP"
awslocal --endpoint-url="$LOCALSTACK_ENDPOINT" logs create-log-group \
  --log-group-name "$LOG_GROUP" --region "$AWS_DEFAULT_REGION" || true

echo "==> Recursos creados (o existentes)."
