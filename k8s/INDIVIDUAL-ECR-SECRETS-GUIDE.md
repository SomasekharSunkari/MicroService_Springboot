# Individual ECR Secrets Configuration Guide

## Overview
This configuration creates individual ECR Docker registry secrets for each service, providing better isolation and security. Each service has its own dedicated imagePullSecret.

## Service-to-Secret Mapping

| Service | Deployment File | ECR Repository | Secret Name |
|---------|----------------|----------------|-------------|
| Auth Service | `authservice/deployment.yml` | `auth-service` | `ecr-auth-secret` |
| Product Service | `product/deployment.yml` | `product-api` | `ecr-product-secret` |
| Order Service | `order/deployment.yml` | `order-service` | `ecr-order-secret` |
| Notification Service | `notification/deployment.yml` | `notification-service` | `ecr-notification-secret` |
| Payment Service | `payment/deployment.yml` | `payment-service` | `ecr-payment-secret` |
| Client Code | `clientcode/deployment.yml` | `client-service` | `ecr-clientcode-secret` |

## Deployment Steps

### Step 1: Create Individual ECR Secrets

#### Option A: Using the automated script (Recommended)
```bash
chmod +x create-individual-ecr-secrets.sh
./create-individual-ecr-secrets.sh
```

#### Option B: Manual creation for each service
```bash
# Get ECR token
ECR_TOKEN=$(aws ecr get-login-password --region us-east-1)

# Create individual secrets
kubectl create secret docker-registry ecr-auth-secret \
    --docker-server=068856380156.dkr.ecr.us-east-1.amazonaws.com \
    --docker-username=AWS \
    --docker-password="$ECR_TOKEN" \
    --namespace=ecommerce

kubectl create secret docker-registry ecr-product-secret \
    --docker-server=068856380156.dkr.ecr.us-east-1.amazonaws.com \
    --docker-username=AWS \
    --docker-password="$ECR_TOKEN" \
    --namespace=ecommerce

kubectl create secret docker-registry ecr-order-secret \
    --docker-server=068856380156.dkr.ecr.us-east-1.amazonaws.com \
    --docker-username=AWS \
    --docker-password="$ECR_TOKEN" \
    --namespace=ecommerce

kubectl create secret docker-registry ecr-notification-secret \
    --docker-server=068856380156.dkr.ecr.us-east-1.amazonaws.com \
    --docker-username=AWS \
    --docker-password="$ECR_TOKEN" \
    --namespace=ecommerce

kubectl create secret docker-registry ecr-payment-secret \
    --docker-server=068856380156.dkr.ecr.us-east-1.amazonaws.com \
    --docker-username=AWS \
    --docker-password="$ECR_TOKEN" \
    --namespace=ecommerce

kubectl create secret docker-registry ecr-clientcode-secret \
    --docker-server=068856380156.dkr.ecr.us-east-1.amazonaws.com \
    --docker-username=AWS \
    --docker-password="$ECR_TOKEN" \
    --namespace=ecommerce
```

### Step 2: Verify Secret Creation
```bash
# List all ECR secrets
kubectl get secrets -n ecommerce | grep "ecr-.*-secret"

# Verify specific secrets
kubectl get secret ecr-auth-secret -n ecommerce
kubectl get secret ecr-product-secret -n ecommerce
kubectl get secret ecr-order-secret -n ecommerce
kubectl get secret ecr-notification-secret -n ecommerce
kubectl get secret ecr-payment-secret -n ecommerce
kubectl get secret ecr-clientcode-secret -n ecommerce
```

### Step 3: Deploy Services
```bash
# Deploy services with individual secrets
kubectl apply -f authservice/deployment.yml
kubectl apply -f product/deployment.yml
kubectl apply -f order/deployment.yml
kubectl apply -f notification/deployment.yml
kubectl apply -f payment/deployment.yml
kubectl apply -f clientcode/deployment.yml
```

### Step 4: Verify Deployments
```bash
# Check pod status
kubectl get pods -n ecommerce

# Check for ImagePullBackOff errors
kubectl get pods -n ecommerce | grep -E "(ImagePullBackOff|ErrImagePull)"

# Describe specific pods if needed
kubectl describe pod <pod-name> -n ecommerce
```

## Updated Deployment Configurations

### Auth Service (`authservice/deployment.yml`)
```yaml
spec:
  template:
    spec:
      containers:
      - name: auth-service
        image: 068856380156.dkr.ecr.us-east-1.amazonaws.com/auth-service:latest
        # ... other configurations
      imagePullSecrets:
        - name: ecr-auth-secret
```

### Product Service (`product/deployment.yml`)
```yaml
spec:
  template:
    spec:
      containers:
      - name: product-service
        image: 068856380156.dkr.ecr.us-east-1.amazonaws.com/product-api:latest
        # ... other configurations
      imagePullSecrets:
        - name: ecr-product-secret
```

### Order Service (`order/deployment.yml`)
```yaml
spec:
  template:
    spec:
      containers:
      - name: order-service
        image: 068856380156.dkr.ecr.us-east-1.amazonaws.com/order-service:latest
        # ... other configurations
      imagePullSecrets:
        - name: ecr-order-secret
```

### Notification Service (`notification/deployment.yml`)
```yaml
spec:
  template:
    spec:
      containers:
      - name: notification-service
        image: 068856380156.dkr.ecr.us-east-1.amazonaws.com/notification-service:latest
        # ... other configurations
      imagePullSecrets:
        - name: ecr-notification-secret
```

### Payment Service (`payment/deployment.yml`)
```yaml
spec:
  template:
    spec:
      containers:
      - name: payment-service
        image: 068856380156.dkr.ecr.us-east-1.amazonaws.com/payment-service:latest
        # ... other configurations
      imagePullSecrets:
        - name: ecr-payment-secret
```

### Client Code (`clientcode/deployment.yml`)
```yaml
spec:
  template:
    spec:
      containers:
      - name: clientcode
        image: 068856380156.dkr.ecr.us-east-1.amazonaws.com/client-service:latest
        # ... other configurations
      imagePullSecrets:
        - name: ecr-clientcode-secret
```

## Benefits of Individual Secrets

1. **Better Security Isolation**: Each service has its own secret
2. **Granular Access Control**: Can set different permissions per service
3. **Easier Troubleshooting**: Issues are isolated to specific services
4. **Flexible Management**: Can rotate secrets independently
5. **Audit Trail**: Better tracking of which service uses which secret

## Maintenance

### Token Rotation
Since ECR tokens expire every 12 hours, you'll need to rotate them:

```bash
# Rotate all secrets at once
./create-individual-ecr-secrets.sh

# Or rotate individual secrets
ECR_TOKEN=$(aws ecr get-login-password --region us-east-1)
kubectl delete secret ecr-auth-secret -n ecommerce
kubectl create secret docker-registry ecr-auth-secret \
    --docker-server=068856380156.dkr.ecr.us-east-1.amazonaws.com \
    --docker-username=AWS \
    --docker-password="$ECR_TOKEN" \
    --namespace=ecommerce
```

### Restart Deployments After Secret Update
```bash
kubectl rollout restart deployment auth-service-deployment -n ecommerce
kubectl rollout restart deployment product-service-deployment -n ecommerce
kubectl rollout restart deployment order-service-deployment -n ecommerce
kubectl rollout restart deployment notification-service-deployment -n ecommerce
kubectl rollout restart deployment payment-service-deployment -n ecommerce
kubectl rollout restart deployment clientcode-deployment -n ecommerce
```

## Troubleshooting

### Common Issues
1. **Secret not found**: Ensure the secret name matches exactly in the deployment
2. **Token expired**: Recreate the secrets with fresh ECR tokens
3. **Wrong namespace**: Ensure secrets are created in the `ecommerce` namespace
4. **Permission issues**: Verify AWS credentials have ECR access

### Verification Commands
```bash
# Check if secret exists and is properly formatted
kubectl get secret ecr-auth-secret -n ecommerce -o yaml

# Check deployment events
kubectl describe deployment auth-service-deployment -n ecommerce

# Check pod events
kubectl describe pod <pod-name> -n ecommerce
```