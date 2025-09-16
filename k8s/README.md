# Kubernetes Manifests for E-commerce Microservices

This directory contains Kubernetes manifests for deploying the complete e-commerce microservices architecture.

## Architecture Overview

### External Access (Internet Users) - Path-Based Routing
Based on your ECS load balancer analysis, multiple services are publicly accessible:

- **ClientCode** (Frontend) - React application - Default route `/`
- **AuthService** - Authentication API - `/api/v1/auth/*` → port 8787
- **OrderService** - Order processing API - `/api/v1/orders/*` → port 8070
- **ProductService** - Product catalog API - `/api/v1/products/*` → port 8050
- **PaymentService** - Payment processing API - `/api/v1/payments/*` → port 8060

### Internal Services (Private Network Only)
- **ConfigServer** - Centralized configuration management (port 8888)
- **Discovery** - Eureka service registry (port 8761)
- **Gateway** - Internal API Gateway (port 8222) - **NOT externally accessible**
- **Customer** - Customer management service
- **Notification** - Email notification service (port 8040)

**Communication Pattern:**
- **External users** access services via path-based routing (single load balancer)
- **Internal communication** uses Kubernetes DNS for service discovery
- Load balancer routes API calls directly to backend services (no gateway for external API calls)

## Directory Structure

```
k8s/
├── shared/
│   ├── namespace.yml       # ecommerce namespace
│   ├── configmaps.yml      # Shared configuration
│   ├── secrets.yml         # Database and mail secrets
│   └── ingress.yml         # External access configuration
├── configserver/
│   ├── deployment.yml
│   └── service.yml
├── discovery/
│   ├── deployment.yml
│   └── service.yml
├── gateway/
│   ├── deployment.yml
│   └── service.yml
├── authservice/
│   ├── deployment.yml
│   └── service.yml
├── customer/
│   ├── deployment.yml
│   └── service.yml
├── product/
│   ├── deployment.yml
│   └── service.yml
├── order/
│   ├── deployment.yml
│   └── service.yml
├── payment/
│   ├── deployment.yml
│   └── service.yml
├── notification/
│   ├── deployment.yml
│   └── service.yml
├── clientcode/
│   ├── deployment.yml
│   └── service.yml
├── deploy.sh               # Automated deployment script
└── README.md              # This file
```

## Prerequisites

1. **Kubernetes Cluster** - Running cluster with kubectl configured
2. **NGINX Ingress Controller** - For external access
   ```bash
   kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.1/deploy/static/provider/cloud/deploy.yaml
   ```
3. **Docker Images** - All microservice images should be built and available
4. **External Services** - PostgreSQL database and Kafka cluster should be accessible

## Deployment

### Option 1: Automated Deployment (Recommended)
```bash
cd k8s
chmod +x deploy.sh
./deploy.sh
```

### Option 2: Manual Deployment
Deploy in the following order to respect dependencies:

```bash
# 1. Create namespace and shared resources
kubectl apply -f shared/namespace.yml
kubectl apply -f shared/configmaps.yml
kubectl apply -f shared/secrets.yml

# 2. Deploy infrastructure services
kubectl apply -f configserver/
kubectl apply -f discovery/
kubectl apply -f gateway/

# 3. Wait for infrastructure to be ready
kubectl wait --for=condition=ready pod -l app=configserver -n ecommerce --timeout=300s
kubectl wait --for=condition=ready pod -l app=discovery -n ecommerce --timeout=300s

# 4. Deploy business services
kubectl apply -f authservice/
kubectl apply -f customer/
kubectl apply -f product/
kubectl apply -f order/
kubectl apply -f payment/
kubectl apply -f notification/

# 5. Deploy frontend
kubectl apply -f clientcode/

# 6. Deploy ingress
kubectl apply -f shared/ingress.yml
```

## Access Points

### For Local Development
Add to `/etc/hosts` (Linux/Mac) or `C:\Windows\System32\drivers\etc\hosts` (Windows):
```
127.0.0.1 ecommerce.local
127.0.0.1 api.ecommerce.local
```

### URLs
- **Frontend Application**: http://ecommerce.local/
- **Authentication API**: http://ecommerce.local/api/v1/auth/*
- **Order API**: http://ecommerce.local/api/v1/orders/*
- **Product API**: http://ecommerce.local/api/v1/products/*
- **Payment API**: http://ecommerce.local/api/v1/payments/*
- **Internal Services**: Internal access only via Kubernetes DNS (e.g., `notification-service.ecommerce.svc.cluster.local:8040`)

## Useful Commands

```bash
# Check deployment status
kubectl get all -n ecommerce

# Check pod status
kubectl get pods -n ecommerce

# Check services
kubectl get services -n ecommerce

# Check ingress
kubectl get ingress -n ecommerce

# View logs for a specific service
kubectl logs -f deployment/gateway-deployment -n ecommerce
kubectl logs -f deployment/auth-service-deployment -n ecommerce

# Scale a service
kubectl scale deployment gateway-deployment --replicas=3 -n ecommerce

# Port forward for debugging (alternative access)
kubectl port-forward service/gateway-service 8222:8222 -n ecommerce
kubectl port-forward service/clientcode-service 8080:80 -n ecommerce
```

## Configuration Details

### ConfigMaps
- **database-config**: Database connection settings
- **kafka-config**: Kafka bootstrap servers
- **service-urls**: Internal service URLs
- **mail-config**: SMTP configuration

### Secrets
- **database-secrets**: Database password
- **mail-secrets**: Email password

### Resource Allocation
- **Infrastructure Services**: 256Mi-512Mi RAM, 250m-500m CPU
- **Business Services**: 512Mi-1Gi RAM, 500m-1000m CPU
- **Frontend**: 128Mi-256Mi RAM, 100m-200m CPU

## Scaling Considerations

1. **Gateway Service**: Already configured with 2 replicas for load balancing
2. **Business Services**: All configured with 2 replicas for high availability
3. **Database**: Uses external PostgreSQL RDS
4. **Message Queue**: Uses external Kafka cluster

## Security Notes

- All services run within the `ecommerce` namespace
- **Multiple services are externally accessible** via path-based routing (matches your ECS architecture)
- External access: frontend, auth, order, product, payment services
- Internal only: config-server, discovery, notification, customer services
- Sensitive data stored in Kubernetes secrets
- Network policies can be added for additional security
- Services communicate internally via Kubernetes DNS resolution

## Troubleshooting

1. **Pods not starting**: Check logs with `kubectl logs <pod-name> -n ecommerce`
2. **Services not accessible**: Verify service and ingress configuration
3. **Database connection issues**: Check ConfigMap and Secret values
4. **Inter-service communication**: Ensure Eureka discovery is working

For more detailed troubleshooting, check individual service logs and ensure all external dependencies (database, Kafka) are accessible from the cluster.