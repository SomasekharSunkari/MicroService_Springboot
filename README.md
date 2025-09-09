# MicroService_Springboot
## Endpoint Checks
1 http://localhost:8222/api/v1/customers -> Customer Post request
input demo Value : 
{
"id": 1,
"firstname": "sekhar",
"lastname": "demo",
"email":"sunkarisekhar36@gmail.com",
"address":{
"street":"Street Name",
"houseNumber": "!23",
"zipCode": "50003"
}
}

// Create ECR repos for Microsevices
//Codestar connection 
// Code build project for each microservice
// ECS task defintion and Service
// code pipline for each microserice (Referncing Code build from step three and ECS service from step 4 )