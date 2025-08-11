# Instrucciones para crear recursos AWS en LocalStack

## Objetivo
Crear manualmente los recursos AWS necesarios para el proyecto "La Huella" usando LocalStack y AWS CLI.

## Configuración inicial
- **Endpoint**: `http://localhost:4566`
- **Región**: `eu-west-1`
- **Herramienta**: `awslocal` (AWS CLI para LocalStack)

## Recursos a crear

### 1. Almacenamiento S3
Debes crear **2 buckets**:
- `la-huella-sentiment-reports` (para reportes de análisis)
- `la-huella-uploads` (para archivos subidos)

**Tareas**:
- Investigar comando para crear buckets S3
- Configurar política pública de lectura para el bucket de uploads
- Permitir acceso público a objetos con acción `s3:GetObject`

### 2. Base de datos DynamoDB
Crear **3 tablas** con las siguientes especificaciones:

#### Tabla `la-huella-comments`
- **Clave primaria**: `id` (String)
- **Índice secundario global**: `ProductIndex`
  - Hash key: `productId` (String)
  - Range key: `createdAt` (String)
- **Capacidad**: 5 unidades lectura/escritura

#### Tabla `la-huella-products`
- **Clave primaria**: `id` (String)
- **Índice secundario global**: `CategoryIndex`
  - Hash key: `category` (String)
- **Capacidad**: 5 unidades lectura/escritura

#### Tabla `la-huella-analytics`
- **Clave primaria compuesta**:
  - Hash key: `id` (String)
  - Range key: `date` (String)
- **Capacidad**: 5 unidades lectura/escritura

**Tareas**:
- Investigar comandos para crear tablas DynamoDB
- Aprender sobre índices secundarios globales
- Configurar esquemas de claves y capacidad provisionada

### 3. Colas SQS
Crear **3 colas**:
- `la-huella-processing-queue` (procesamiento principal)
- `la-huella-notifications-queue` (notificaciones)
- `la-huella-processing-dlq` (cola de mensajes fallidos)

**Tareas**:
- Investigar comandos para crear colas SQS
- Entender el concepto de Dead Letter Queue (DLQ)

### 4. Logs CloudWatch
Crear **2 grupos de logs**:
- `/la-huella/sentiment-analysis`
- `/la-huella/api`

**Tareas**:
- Investigar comandos para crear grupos de logs
- Entender la nomenclatura de grupos de logs


## Verificación
Al finalizar deberás tener:
- 2 buckets S3 funcionales
- 3 tablas DynamoDB con índices
- 3 colas SQS operativas
- 2 grupos de logs CloudWatch

## Recursos de investigación
- Documentación AWS CLI para S3, DynamoDB, SQS y CloudWatch
- Guías de LocalStack
- Ejemplos de políticas IAM para S3
