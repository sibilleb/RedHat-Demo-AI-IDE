# Essential MCP Servers for Red Hat Ansible Product Demos

This document outlines the comprehensive suite of **10 MCP (Model Context Protocol) servers** included in your Red Hat demo environment, providing AI-enhanced capabilities for Ansible, AWS, Terraform, Kubernetes, and DevOps workflows.

## 🔥 Primary/Must-Have Servers (Cursor & Claude Compatible)

### 1. **Ansible Automation Platform MCP Server**
- **Repository**: `rlopez133/mcp-ansible-automation-platform`
- **Package**: `@rlopez133/mcp-ansible-automation-platform`
- **Features**:
  - Direct integration with Ansible Tower/AWX
  - Playbook execution and management
  - Inventory management
  - Job template operations
  - Real-time job monitoring
- **Environment Variables**:
  ```bash
  ANSIBLE_TOWER_HOST=your-tower-host.com
  ANSIBLE_TOWER_USERNAME=your-username
  ANSIBLE_TOWER_PASSWORD=your-password
  ANSIBLE_TOWER_TOKEN=your-api-token  # Alternative to username/password
  ```
- **Perfect for**: Core Ansible automation demos, AWX/Tower integration, enterprise automation workflows

### 2. **AWS MCP Servers Suite (Official by AWS Labs)**
#### AWS Documentation Server
- **Repository**: `awslabs/mcp-aws-documentation`
- **Package**: `@awslabs/mcp-aws-documentation`
- **Features**: Real-time AWS service documentation, API references, best practices

#### AWS EKS Server
- **Repository**: `awslabs/mcp-aws-eks`
- **Package**: `@awslabs/mcp-aws-eks`
- **Features**: EKS cluster management, pod operations, OpenShift compatibility
- **Perfect for**: OpenShift on AWS demos, container orchestration

#### AWS ECS Server
- **Repository**: `awslabs/mcp-aws-ecs`
- **Package**: `@awslabs/mcp-aws-ecs`
- **Features**: Container service management, task definitions, service scaling

#### AWS CDK Server
- **Repository**: `awslabs/mcp-aws-cdk`
- **Package**: `@awslabs/mcp-aws-cdk`
- **Features**: Infrastructure as Code with CDK, stack management

#### AWS Cost Analysis Server
- **Repository**: `awslabs/mcp-aws-cost-analysis`
- **Package**: `@awslabs/mcp-aws-cost-analysis`
- **Features**: Cost optimization, usage analytics, billing insights

**Common Environment Variables for AWS Servers**:
```bash
AWS_ACCESS_KEY_ID=your-access-key
AWS_SECRET_ACCESS_KEY=your-secret-key
AWS_DEFAULT_REGION=us-east-1
```

### 3. **HashiCorp Terraform MCP Server (Official)**
- **Repository**: `hashicorp/terraform-mcp-server`
- **Package**: `@hashicorp/terraform-mcp-server`
- **Features**:
  - Terraform provider discovery
  - Module management and operations
  - Infrastructure as Code automation
  - Plan and apply operations
  - State management
- **Environment Variables**:
  ```bash
  TERRAFORM_CLOUD_TOKEN=your-terraform-cloud-token
  TF_VAR_aws_access_key=your-aws-access-key
  TF_VAR_aws_secret_key=your-aws-secret-key
  ```
- **Perfect for**: Infrastructure as Code demos, multi-cloud provisioning

### 4. **GitHub MCP Server (Official)**
- **Repository**: Official GitHub MCP server
- **Package**: `@modelcontextprotocol/server-github`
- **Features**:
  - Repository management
  - Pull request automation
  - Workflow integration
  - Issue tracking
  - Branch operations
- **Environment Variables**:
  ```bash
  GITHUB_PERSONAL_ACCESS_TOKEN=your-github-token
  ```
- **Perfect for**: Version control demos, CI/CD integration, GitOps workflows

## 🚀 Infrastructure & DevOps Servers

### 5. **Kubernetes MCP Server**
- **Repository**: `Flux159/mcp-server-kubernetes`
- **Package**: `@flux159/mcp-server-kubernetes`
- **Features**:
  - Pod management and operations
  - Log access and monitoring
  - Resource monitoring
  - Deployment management
  - Service operations
- **Environment Variables**:
  ```bash
  KUBECONFIG=/path/to/your/kubeconfig
  KUBERNETES_NAMESPACE=default
  ```
- **Perfect for**: OpenShift/Kubernetes automation demos, container orchestration

### 6. **Docker MCP Server**
- **Repository**: `docker/mcp-servers`
- **Package**: `@docker/mcp-docker`
- **Features**:
  - Container management
  - Image operations
  - Docker Compose integration
  - Registry operations
- **Environment Variables**:
  ```bash
  DOCKER_HOST=unix:///var/run/docker.sock
  ```
- **Perfect for**: Execution environment development, container demos

### 7. **Task Master AI**
- **Package**: `task-master-ai`
- **Features**:
  - Project task management
  - AI-powered task breakdown
  - Development workflow automation
  - Progress tracking
- **Environment Variables**: Multiple AI provider API keys (see template)
- **Perfect for**: Demo project management, development planning

## 🔧 Configuration and Setup

### Automatic Configuration
All MCP servers are automatically configured during the one-click setup process. The setup script:

1. **Copies the MCP template** to `.cursor/mcp.json`
2. **Prompts for essential API keys** during setup
3. **Validates connectivity** to critical services
4. **Provides guidance** for completing configuration

### Manual Configuration
If you need to manually configure any server:

1. **Edit `.cursor/mcp.json`** in your project root
2. **Replace placeholder values** with your actual credentials
3. **Restart Cursor** to load the new configuration
4. **Test the connection** through Cursor's AI chat

### Security Best Practices

- **Never commit `.cursor/mcp.json`** with real credentials (it's gitignored)
- **Use environment-specific tokens** with minimal required permissions
- **Rotate API keys regularly** for security
- **Use service accounts** instead of personal tokens where possible

## 📊 Integration Matrix

| Server | Ansible Demos | AWS Infrastructure | IaC/Terraform | Container/K8s | DevOps/CI-CD |
|--------|---------------|-------------------|---------------|---------------|--------------|
| Ansible Automation Platform | ✅ Primary | ✅ Provision | ✅ Orchestrate | ✅ Deploy | ✅ Automate |
| AWS Suite | ✅ Target | ✅ Primary | ✅ Backend | ✅ Platform | ✅ Infrastructure |
| Terraform | ✅ Provision | ✅ Manage | ✅ Primary | ✅ Setup | ✅ Infrastructure |
| GitHub | ✅ Store | ✅ CI/CD | ✅ Version | ✅ GitOps | ✅ Primary |
| Kubernetes | ✅ Deploy | ✅ Runtime | ✅ Target | ✅ Primary | ✅ Platform |
| Docker | ✅ Package | ✅ Runtime | ✅ Images | ✅ Foundation | ✅ Build |

## 🎯 Demo Use Cases

### Enterprise Automation Demo
1. **Use Ansible MCP** to create and execute playbooks
2. **Use AWS MCP** to provision infrastructure
3. **Use Terraform MCP** for Infrastructure as Code
4. **Use GitHub MCP** for version control and CI/CD

### Cloud Migration Demo
1. **Use AWS Documentation MCP** for service guidance
2. **Use Terraform MCP** for infrastructure planning
3. **Use Kubernetes MCP** for container orchestration
4. **Use Ansible MCP** for configuration management

### DevOps Pipeline Demo
1. **Use GitHub MCP** for source control
2. **Use Docker MCP** for containerization
3. **Use Kubernetes MCP** for deployment
4. **Use AWS Cost Analysis MCP** for optimization

## 🔍 Troubleshooting

### Common Issues

**MCP Server Not Loading**:
- Check `.cursor/mcp.json` syntax
- Verify API keys are correctly set
- Restart Cursor completely

**Authentication Errors**:
- Validate API key permissions
- Check network connectivity
- Verify service endpoints

**Performance Issues**:
- Disable unused servers in configuration
- Check rate limits on API keys
- Monitor system resources

### Getting Help

1. **Check server-specific documentation** in their repositories
2. **Review Cursor MCP logs** in the developer console
3. **Test connectivity** with CLI tools first
4. **Consult the setup guide** for configuration details

## 📚 Additional Resources

- [Model Context Protocol Specification](https://modelcontextprotocol.io/)
- [Cursor MCP Documentation](https://docs.cursor.com/mcp)
- [AWS Labs MCP Servers](https://github.com/awslabs/mcp)
- [HashiCorp Terraform MCP](https://github.com/hashicorp/terraform-mcp-server)
- [Ansible Automation Platform](https://www.redhat.com/en/technologies/management/ansible)

---

*This comprehensive MCP server suite transforms your development environment into an AI-enhanced powerhouse for Red Hat product demonstrations and enterprise automation workflows.* 