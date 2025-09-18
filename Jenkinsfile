pipeline {
    agent { label "node-1" }
    tools {
        maven "maven-3"
    }
    environment {
        DOCKER_REGISTRY = 'sunkarisomasekhar'
    }

    stages {
        stage("Clear workspace") {
            steps { cleanWs() }
        }

        stage("Checkout") {
            steps {
                git branch: 'main', url: 'https://github.com/SomasekharSunkari/MicroService_Springboot.git'
            }
        }

        stage("Build & Deploy Microservices") {
            parallel {
                
                 stage("Auth-Service") {
                    when { changeset "authservice/**" }
                    steps {
                        dir("authservice") {
                            script {
                                docker.withRegistry('https://index.docker.io/v1/', 'docker-hub-cred') {
                                    def img = docker.build("${DOCKER_REGISTRY}/auth-service:${env.BUILD_NUMBER}")
                                    img.push()
                                }
                            }
                            sh """
                                sed -i 's|image: .*|image: ${DOCKER_REGISTRY}/auth-service:${BUILD_NUMBER}|' deployment.yml
                            """
                            withKubeConfig(credentialsId: 'k8s-creds') {
                                sh 'kubectl apply -f deployment.yml -n jenkins'
                                sh 'kubectl rollout status -n jenkins deployment/auth-service-deployment'
                            }
                        }
                    }
                }
                 stage("Client-Service") {
                    when { changeset "clientCode/**" }
                    steps {
                        dir("clientCode") {
                            script {
                                docker.withRegistry('https://index.docker.io/v1/', 'docker-hub-cred') {
                                    def img = docker.build("${DOCKER_REGISTRY}/client-svc:${env.BUILD_NUMBER}")
                                    img.push()
                                }
                            }
                            sh """
                                sed -i 's|image: .*|image: ${DOCKER_REGISTRY}/client-svc:${BUILD_NUMBER}|' deployment.yml
                            """
                            withKubeConfig(credentialsId: 'k8s-creds') {
                                sh 'kubectl apply -f deployment.yml -n jenkins'
                                sh 'kubectl rollout status -n jenkins deployment/clientcode-deployment'
                            }
                        }
                    }
                }
                 stage("Notification-Service") {
                    when { changeset "notification/**" }
                    steps {
                        dir("notification") {
                            script {
                                docker.withRegistry('https://index.docker.io/v1/', 'docker-hub-cred') {
                                    def img = docker.build("${DOCKER_REGISTRY}/notification:${env.BUILD_NUMBER}")
                                    img.push()
                                }
                            }
                            sh """
                                sed -i 's|image: .*|image: ${DOCKER_REGISTRY}/notification:${BUILD_NUMBER}|' deployment.yml
                            """
                            withKubeConfig(credentialsId: 'k8s-creds') {
                                sh 'kubectl apply -f deployment.yml -n jenkins'
                                sh 'kubectl rollout status -n jenkins deployment/notification-service-deployment'
                            }
                        }
                    }
                }
                 stage("Order-Service") {
                    when { changeset "order/**" }
                    steps {
                        dir("order") {
                            script {
                                docker.withRegistry('https://index.docker.io/v1/', 'docker-hub-cred') {
                                    def img = docker.build("${DOCKER_REGISTRY}/order-svc:${env.BUILD_NUMBER}")
                                    img.push()
                                }
                            }
                            sh """
                                sed -i 's|image: .*|image: ${DOCKER_REGISTRY}/order-svc:${BUILD_NUMBER}|' deployment.yml
                            """
                            withKubeConfig(credentialsId: 'k8s-creds') {
                                sh 'kubectl apply -f deployment.yml -n jenkins'
                                sh 'kubectl rollout status -n jenkins deployment/order-service-deployment'
                            }
                        }
                    }
                }
                 stage("Payment-Service") {
                    when { changeset "payment/**" }
                    steps {
                        dir("payment") {
                            script {
                                docker.withRegistry('https://index.docker.io/v1/', 'docker-hub-cred') {
                                    def img = docker.build("${DOCKER_REGISTRY}/payment-svc:${env.BUILD_NUMBER}")
                                    img.push()
                                }
                            }
                            sh """
                                sed -i 's|image: .*|image: ${DOCKER_REGISTRY}/payment-svc:${BUILD_NUMBER}|' deployment.yml
                            """
                            withKubeConfig(credentialsId: 'k8s-creds') {
                                sh 'kubectl apply -f deployment.yml -n jenkins'
                                sh 'kubectl rollout status -n jenkins deployment/payment-service-deployment'
                            }
                        }
                    }
                }
                stage("Product-Service") {
                    when { changeset "product/**" }
                    steps {
                        dir("product") {
                            script {
                                docker.withRegistry('https://index.docker.io/v1/', 'docker-hub-cred') {
                                    def img = docker.build("${DOCKER_REGISTRY}/product-svc:${env.BUILD_NUMBER}")
                                    img.push()
                                }
                            }
                            sh """
                                sed -i 's|image: .*|image: ${DOCKER_REGISTRY}/product-svc:${BUILD_NUMBER}|' deployment.yml
                            """
                            withKubeConfig(credentialsId: 'k8s-creds') {
                                sh 'kubectl apply -f deployment.yml -n jenkins'
                                sh 'kubectl rollout status -n jenkins deployment/product-service-deployment'
                            }
                        }
                    }
                }

                // Add other services here in same way
            }
        }
    }
}
