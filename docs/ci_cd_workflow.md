### **Stream Consumer CI/CD Workflow**

This GitHub Actions workflow automates the **build**, **test**, and **deployment** process for the `stream_consumer` service. It ensures that Docker images are consistently built, tagged, and pushed to the **GitHub Container Registry (GHCR)** for different environments (e.g., development and production). The workflow can be triggered automatically on code changes or manually for specific deployment needs.

---

### **Workflow Overview**

1. **Triggers**:
   - **Push**: Automatically triggered on every push to any branch.
   - **Pull Request**: Automatically triggered on pull requests to any branch.
   - **Manual Trigger**: Can be manually triggered using the `workflow_dispatch` event, allowing you to specify the target environment.

2. **Environment Matrix**:
   - The workflow supports multiple environments (`dev` and `prod`) using a matrix strategy. This allows parallel builds for different environments.

3. **Key Steps**:
   - **Checkout Repository**: Clones the repository to the GitHub Actions runner.
   - **Set Up Docker Buildx**: Prepares the environment for advanced Docker builds.
   - **Build and Push Docker Image**: Builds the Docker image for the `stream_consumer` service and pushes it to the GitHub Container Registry with appropriate tags.

4. **Container Registry**:
   - The workflow uses **GHCR** (`ghcr.io`) to store and manage Docker images. Images are tagged based on the environment (e.g., `dev`, `prod`) and the commit SHA for traceability.

---

### **Usage**

#### **Automatic Triggers**
- **Push to Any Branch**:
  - The workflow is triggered automatically on every push to any branch. This ensures that changes are built and pushed to the container registry for testing or deployment.

- **Pull Requests**:
  - The workflow runs automatically for pull requests, allowing you to validate changes before merging.

#### **Manual Trigger**
- You can manually trigger the workflow using the `workflow_dispatch` event. This is useful for deploying to specific environments on demand.

**Steps to Manually Trigger the Workflow**:
1. Go to the **Actions** tab in your GitHub repository.
2. Select the **Stream Consumer CI/CD Workflow**.
3. Click the **Run workflow** button.
4. Choose the target environment (default: `development`) and start the workflow.

---

### **Environment Variables**

The workflow uses the following environment variables:

| Variable       | Description                                      |
|----------------|--------------------------------------------------|
| `REGISTRY`     | The container registry to push images to (GHCR). |
| `GITHUB_TOKEN` | Used to authenticate with the container registry.|

---

### **Secrets**

The following secrets must be configured in your GitHub repository for the workflow to function:

| Secret Name      | Description                                      |
|------------------|--------------------------------------------------|
| `GHCR_TOKEN`     | Personal Access Token (PAT) with `write:packages` scope for GHCR. |

---

### **Docker Image Tagging**

The workflow tags Docker images based on the environment and commit SHA for traceability:

- **Development**: `ghcr.io/<organization>/stream_consumer:dev`
- **Production**: `ghcr.io/<organization>/stream_consumer:prod`

---

### **Extending the Workflow**

You can extend this workflow to include additional steps, such as:
- Running unit tests or integration tests before building the Docker image.
- Deploying the built image to a remote server or Kubernetes cluster.
- Adding more environments (e.g., staging, QA) to the matrix.

---

### **Example Workflow Execution**

1. **Push to `main` Branch**:
   - The workflow builds the `stream_consumer` service for the `prod` environment and pushes the image to `ghcr.io/<organization>/stream_consumer:prod`.

2. **Pull Request to `develop` Branch**:
   - The workflow validates the changes by building the `stream_consumer` service for the `dev` environment.

3. **Manual Deployment to Development**:
   - Trigger the workflow manually and specify the `development` environment to build and push the image with the `dev` tag.

---

This workflow ensures a streamlined CI/CD process for the `stream_consumer` service, enabling consistent builds, traceable image tagging, and seamless integration with the GitHub Container Registry.
