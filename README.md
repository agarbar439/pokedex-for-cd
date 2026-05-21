# Pokedex App – Cloud Deployment & CI/CD

This project is a containerized web application (Pokedex) deployed on a production-ready, highly available architecture in AWS, utilizing Infrastructure as Code (IaC) and full deployment automation.

## 🏗️ Architecture

The infrastructure is entirely provisioned using **Terraform** and follows modern DevOps practices for container orchestration and networking.

The complete AWS stack includes:
* **Virtual Private Cloud (VPC):** A custom network topology designed with public and private subnets across multiple Availability Zones (AZs) for high availability and isolation.
* **Application Load Balancer (ALB):** Acts as the single entry point, distributing incoming traffic across the application containers and managing health checks.
* **Amazon ECS (Fargate):** A serverless container orchestration service that runs the application without the need to manage physical EC2 instances.
* **Amazon ECR (Elastic Container Registry):** A secure and private Docker registry used to store and version the application images.

### 🔄 Traffic and Deployment Flow:
1. The user requests the application through the **Application Load Balancer (ALB)**.
2. The ALB routes traffic across multiple Availability Zones to the **ECS Fargate tasks** running inside the private subnets.
3. Fargate automatically scales and manages the containers, ensuring **Zero-Downtime** updates when new versions are deployed.

---

## 🔒 Security (DevSecOps)

Security was treated as a first-class citizen throughout the development and deployment lifecycle:

* **Network Isolation:** The ECS containers running the application are isolated inside private subnets, meaning they are not directly accessible from the public internet. They only accept traffic routed through the ALB.
* **Static Code Analysis (SCA):** Integrated **Snyk** into the CI/CD pipeline to automatically scan the code and Docker base images for vulnerabilities before building.
* **Least-Privilege Access:** The GitHub Actions deployment worker uses dedicated IAM credentials strictly limited to pushing images to ECR and updating the ECS service.

---

## 🤖 Automation with GitHub Actions (CI/CD)

Every `push` or `pull request` to the `main` branch automatically triggers a robust "Push-to-Deploy" workflow that executes the following steps:

1.  **Security Scan:** Runs **Snyk** to check for security flaws in the dependencies and Dockerfile.
2.  **Docker Build:** Packages the web application into a lightweight Docker image.
3.  **Amazon ECR Push:** Authenticates securely with AWS using GitHub Secrets (`AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`) and pushes the tagged image to the registry.
4.  **ECS Deployment:** Signals Amazon ECS to perform a rolling update. The old containers are only replaced once the new ones pass healthy status checks (**Zero-Downtime Deployment**).

---

## 💰 Costs & Optimization

By choosing a **serverless** and modern architecture, fixed infrastructure costs are minimized. Below is an approximate estimation based on official AWS Europe pricing for a low-to-medium traffic hobby/portfolio project:

* **Amazon ECS Fargate:** Since Fargate charges per CPU/Memory per second, utilizing the smallest task size (e.g., 0.25 vCPU, 0.5 GB RAM) keeps costs under **~€0.01 per hour** of active running.
* **Application Load Balancer (ALB):** Charged per hour and LCU (Load Balancer Capacity Units) $\rightarrow$ **~€0.025/hour**.
* **Amazon ECR:** Storage cost is **€0.10 per GB/month**. Since images are optimized, storage consumption is negligible.
* **AWS Free Tier:** Many core networking components (like data transfer limits) fall under the AWS Free Tier for the first 12 months.

---

## 🛠️ Problems and Solutions

### Problem 1: High Availability Configuration in Fargate
* **Challenge:** Initially, configuring ECS Fargate to deploy across multiple Availability Zones caused target group routing errors.
* **Solution:** Correctly structured the Terraform subnets map and attached the ALB to public subnets while routing target groups explicitly to the private subnets' tasks.

### Problem 2: ECR Authentication in GitHub Actions
* **Challenge:** Securely logging into AWS ECR from an external runner without exposing permanent long-term credentials in code.
* **Solution:** Implemented the `aws-actions/configure-aws-credentials` action using encrypted GitHub Secrets, ensuring tokens are masked in logs and strictly scoped.

---

## 🧰 Tech Stack

* **Infrastructure as Code:** Terraform
* **Cloud Provider:** AWS (VPC, ALB, ECS Fargate, ECR, IAM)
* **Containerization:** Docker
* **CI/CD Pipeline:** GitHub Actions
* **Security Scanning:** Snyk

<img width="1380" height="752" alt="infrastructure_cloud" src="https://github.com/user-attachments/assets/300e23a9-8f09-4385-896d-7670996add6c" />

