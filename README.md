# Devops-Portfolio
# Automated Multi-Cloud DevOps Portfolio Deployment Architecture

A production-ready, Infrastructure-as-Code (IaC) deployment pipeline that containerizes a professional engineering portfolio website and dynamically provisions a fully isolated, custom cloud network layer on AWS to host the containerized application.

---

## 🏗️ Architecture Overview

Instead of deploying into a standard default cloud environment, this project programmatically builds a secure, isolated virtual network from scratch in the **ap-south-2 (Hyderabad)** region.

### Core Architectural Components:
* **Isolated Cloud Network (VPC):** A dedicated `10.0.0.0/16` Virtual Private Cloud to segregate project infrastructure.
* **Public Routing Layer:** A custom public subnet paired with an AWS Internet Gateway and explicit Route Table associations to facilitate inbound and outbound web traffic.
* **Firewall Infrastructure (Security Groups):** Layer 4 network filtering allowing ingress traffic strictly on Port `80` (HTTP) for public accessibility and Port `22` (SSH) for administrative configuration management.
* **Container Host Engine (EC2):** A `t3.micro` compute instance hosting a microservice-optimized container stack.

---

## 🛠️ Technology Stack

* **Frontend Engine:** Semantic HTML5, Custom CSS3 Modern Dark Theme layout, Vanilla asynchronous JavaScript navigation logic.
* **Container Runtime Engine:** Docker via a lightweight, secure Nginx-Alpine base image environment mirror.
* **Infrastructure as Code (IaC):** Terraform CLI using declarative HashiCorp Configuration Language (HCL) binary blocks.
* **Cloud Infrastructure Ecosystem:** Amazon Web Services (AWS Core Compute & VPC Core Networking components).

---

## 📋 Comprehensive Step-by-Step Implementation

This project was built systematically using standard DevOps lifecycle workflows:

### Phase 1: Local Code Isolation & Containerization
1. Constructed core frontend viewport assets (`index.html`, `style.css`, `script.js`).
2. Engineered a multi-stage `Dockerfile` leveraging an Alpine Linux distribution layer running Nginx to ensure a minimal image footprint ($<30\text{MB}$).
3. Established a `.dockerignore` context map to protect security states from leaking into build cache arrays.

### Phase 2: Programmatic Infrastructure Management (IaC)
1. Created `provider.tf` declaring strict API dependency locks for the official HashiCorp AWS global plugin provider registry.
2. Programmed a dynamic, upstream cloud lookup block using `data "aws_ami"` to programmatically isolate the latest canonical image tracking layer for **Ubuntu 24.04 LTS Minimal Server** editions.
3. Created resource configuration matrices inside `main.tf` mapping out the systematic hierarchy of the cloud network stack (VPC $\rightarrow$ Subnet $\rightarrow$ Internet Gateway $\rightarrow$ Route Tables $\rightarrow$ Security Groups $\rightarrow$ Instance).

### Phase 3: Automated Server Bootstrapping & Orchestration
1. Orchestrated automated host setup actions by injecting a bash runtime array straight into the EC2 instance's configuration block via metadata **User Data** tags.
2. At boot time, the bare metal host natively runs the provisioning scripts:
   * Run a silent apt package cache index synchronization sweep (`apt-get update`).
   * Fetch, configure, register, and activate the local Docker container runtime socket engine.
   * Initialize a native Git terminal clone stream pulling down source files directly from the public GitHub repository.
   * Trigger a synchronous Docker context build sequence (`docker build`) compiling the application image file locally on the node.
   * Spin up and map the active application container process run daemon (`docker run`) to host port `80`.

---

## 🚀 Local Deployment Execution Playbook

Run these commands sequentially in Windows PowerShell to deploy the entire cloud infrastructure from your local machine:

### 1. Link Your AWS Account
Authenticate your terminal workspace with your AWS account credentials:
```powershell
# Open PowerShell and configure your programmatic access keys
aws configure

# Prompts will appear sequentially:
# AWS Access Key ID [None]: Paste_Your_Access_Key_ID
# AWS Secret Access Key [None]: Paste_Your_Secret_Access_Key
# Default region name [None]: ap-south-2
# Default output format [None]: json
```
### 2. Initialize and Run Terraform Pipelines
Navigate to your project folder directory and trigger the declarative infrastructure build:
```powershell
# Change directory to your project workspace folder
cd C:\Users\welcome\desktop\Devops-portfolio

# Download required AWS provider plugins and lock dependencies
terraform init

# Perform a deep semantic static parsing compile run to preview the changes
terraform plan

# Build the complete custom network architecture and host instance live on AWS
terraform apply -auto-approve
```
🌐 Accessing the Live Application
Once the deployment script completes execution, Terraform will automatically output your live production URL in green text directly inside your terminal window:

Outputs:
```
portfolio_public_url = "your_public_url"
```

### Final Step to Host in Browser:
Copy the generated portfolio_public_url string printed at the very end of your PowerShell session.

Open any web browser tab (Chrome, Edge, Brave, etc.).

Paste the URL link into the browser search bar and hit Enter.

Note: On initial boot, the EC2 instance requires approximately 60–90 seconds to silently provision Docker and pull down the code. If the page doesn't load instantly, refresh after one minute.



