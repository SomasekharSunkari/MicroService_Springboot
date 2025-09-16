#!/bin/bash

# Kubernetes Deployment Script for E-commerce Microservices
# This script deploys all microservices in the correct order

echo "🚀 Starting E-commerce Microservices Deployment"

# Create namespace first
echo "📦 Creating namespace..."
kubectl apply -f shared/namespace.yml

# Deploy shared resources
echo "⚙️ Deploying shared resources (ConfigMaps, Secrets)..."
kubectl apply -f shared/configmaps.yml
kubectl apply -f shared/secrets.yml

# Deploy infrastructure services first (order matters for dependencies)
echo "🏗️ Deploying infrastructure services..."

echo "  📋 Deploying Config Server..."
kubectl apply -f configserver/

echo "  🔍 Deploying Discovery Service (Eureka)..."
kubectl apply -f discovery/

echo "  🚪 Deploying API Gateway..."
kubectl apply -f gateway/

# Wait for infrastructure services to be ready
echo "⏳ Waiting for infrastructure services to be ready..."
kubectl wait --for=condition=ready pod -l app=configserver -n ecommerce --timeout=300s
kubectl wait --for=condition=ready pod -l app=discovery -n ecommerce --timeout=300s

# Deploy business services
echo "💼 Deploying business services..."

echo "  🔐 Deploying Auth Service..."
kubectl apply -f authservice/

echo "  👥 Deploying Customer Service..."
kubectl apply -f customer/

echo "  📦 Deploying Product Service..."
kubectl apply -f product/

echo "  📝 Deploying Order Service..."
kubectl apply -f order/

echo "  💳 Deploying Payment Service..."
kubectl apply -f payment/

echo "  📧 Deploying Notification Service..."
kubectl apply -f notification/

# Deploy frontend
echo "🌐 Deploying Frontend (Client Code)..."
kubectl apply -f clientcode/

# Deploy ingress for external access
echo "🌍 Deploying Ingress for external access..."
kubectl apply -f shared/ingress.yml

echo "✅ Deployment completed!"
echo ""
echo "📋 Useful commands:"
echo "  kubectl get pods -n ecommerce                    # Check pod status"
echo "  kubectl get services -n ecommerce                # Check services"
echo "  kubectl get ingress -n ecommerce                 # Check ingress"
echo "  kubectl logs -f deployment/<service-name> -n ecommerce  # Check logs"
echo ""
echo "🌐 Access the application:"
echo "  Frontend: http://ecommerce.local (add to /etc/hosts if using local cluster)"
echo "  API Gateway: http://api.ecommerce.local"
echo "  Alternative API access: http://ecommerce.local/api"
echo ""
echo "⚠️  Note: Make sure you have:"
echo "   - Docker images built for all services"
echo "   - NGINX Ingress Controller installed (kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.1/deploy/static/provider/cloud/deploy.yaml)"
echo "   - External database and Kafka accessible from cluster"