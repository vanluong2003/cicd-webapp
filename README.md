# CI/CD Pipeline with Jenkins, SonarQube, Nexus, Docker, Amazon ECR, Amazon ECS

## Project Overview
The project demonstrates a production-like CI/CD pipeline that automates the process of building, testing, analyzing, packaging, and deploying an application to AWS ECS.

### Tech Stack
- Jenkins (CI//CD)
- Maven (Build & Test)
- SonarQube (Code Quality)
- Nexus (Artifact Repository)
- Docker (Containerization)
- AWS ECR (Image Registry)
- AWS ECS (Deployment)
- Slack (Notification)

## Architecture
![Architecture](images/architecture.jpg)

## CI/CD Pipeline Flow
### Pipeline Steps
    1. Developer pushes code to Github
    2. GitHub webhook triggers Jenkins pipeline
    3. Jenkins performs:
        - Fetch source code
        - Build application using Maven
        - Run unit tests
        - Perform code style check (Checkstyle)
        - Analyze code with SonarQube
        - Upload artifact to Nexus
        - Build Docker Image
        - Push image to AWS ECR
        - Deploy to AWS ECS
    4. Send notification to Slack channel

## CI/CD Pipeline Demo 
### Pipeline Stage View
![Jenkins-pipeline](images/jenkins-pipeline.png)
### Console Output
![Jenkins-ConsoleOutput](images/jenkins-consoleoutput.png)
### SonarQube Dashboard
![Sonarqube](images/sonarqube.png)
### Nexus Repository
![Nexus](images/nexus.png)
### Docker image on ECR 
![ECR](images/ecr.png)
### ECS Service Running
![ECR](images/ecs.png)
## Application Running
![Task](images/task.png)
![App](images/prod.png)
## Slack Notification
![Slack](images/slack.png)

## Key Features
- Automated CI/CD pipeline using Jenkins
- Integrated SonarQube Quality Gate
- Artifact versioning with Nexus
- Docker image build and push to AWS ECR
- Deployment to AWS ECS
- Slack notifications for real-time feedback