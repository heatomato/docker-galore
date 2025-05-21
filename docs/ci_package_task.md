### **Package CLI Tool**

The **Package CLI Tool** is a Bash-based utility designed to streamline the management of Docker images for your project. It provides functionality to **build**, **push**, **pull**, **deploy**, and **list** Docker images, making it an essential tool for containerized application workflows.

---

### **Features**
- **Build Docker Images**: Build images from Dockerfiles with customizable options.
- **Push Images**: Push images to container registries like **GitHub Container Registry (GHCR)**.
- **Pull Images**: Pull images from container registries.
- **Deploy Images**: Deploy images to remote servers via SSH.
- **List Images**: List all Docker images related to the project.
- **Version Management**: Check the version of the CLI tool.

---

### **Prerequisites**
1. **GitHub Container Registry (GHCR)**:
   - A **GitHub Personal Access Token (PAT)** with `write:packages` and `read:packages` scopes is required.
   - Add your **GitHub username** and **PAT** to the .env file.
2. **Remote Server** (for deployment):
   - SSH access to the remote server.
   - Docker installed on the remote server.

---

### **Setup**
1. Add the following variables to the .env file in the root directory:
   ```bash
   GITHUB_USERNAME=<your-github-username>
   GITHUB_TOKEN=<your-github-token>
   ```
2. Run as a mise task:
   ```bash
   mise run package <command> [options]
   ```

---

### **Usage**
The CLI tool provides several commands to manage Docker images. Below is the general syntax:

```bash
mise run package <command> [<args=value>]
```

#### **Commands**
| Command   | Description                                      |
|-----------|--------------------------------------------------|
| `list`    | List all Docker images related to the project.   |
| `build`   | Build a Docker image from a Dockerfile.          |
| `push`    | Push a Docker image to a container registry.     |
| `pull`    | Pull a Docker image from a container registry.   |
| `deploy`  | Deploy a Docker image to a remote server.        |
| `help`    | Display help information about the CLI tool.     |
| `version` | Display the current version of the CLI tool.     |

---

### **Options**
| Option           | Description                                      |
|-------------------|--------------------------------------------------|
| `-i, --image`     | The Docker image name (e.g., `stream_consumer`). |
| `-t, --tag`       | The Docker image tag (e.g., `latest`).           |
| `-f, --file`      | Path to the Dockerfile.                          |
| `-r, --registry`  | The container registry (e.g., `ghcr.io`).        |
| `-o, --organization` | The organization name in the registry.        |
| `-s, --stage`     | The build stage (e.g., `dev`, `prod`).           |
| `-h, --host`      | The remote server for deployment.                |

---

### **Examples**

#### **1. List All Docker Images**
```bash
mise run package list
```
- Lists all Docker images related to the project.

#### **2. Build a Docker Image**
```bash
mise run package build --image=stream_consumer --tag=dev --file=Dockerfile
```
- Builds the `stream_consumer` image with the `dev` tag using the specified Dockerfile.

#### **3. Push a Docker Image**
```bash
mise run package push --image=stream_consumer --tag=dev --registry=ghcr.io
```
- Pushes the `stream_consumer:dev` image to the GitHub Container Registry.

#### **4. Pull a Docker Image**
```bash
mise run package pull --image=stream_consumer --tag=dev --registry=ghcr.io
```
- Pulls the `stream_consumer:dev` image from the GitHub Container Registry.

#### **5. Deploy a Docker Image to a Remote Server**
```bash
mise run package deploy --image=stream_consumer --tag=dev --stage=dev --host=user@remote-server
```
- Deploys the `stream_consumer:dev` image to the specified remote server.

#### **6. Display Help**
```bash
mise run package help
```
- Displays detailed usage instructions and available commands.

#### **7. Check Version**
```bash
mise run package version
```
- Displays the current version of the CLI tool.

---

### **Deployment Workflow**
The `deploy` command performs the following steps:
1. **Save the Docker Image**:
   - Saves the specified image as a `.tar` file.
2. **Transfer the Image**:
   - Transfers the `.tar` file to the remote server using `scp`.
3. **Load the Image**:
   - Loads the image into the Docker daemon on the remote server.
4. **(Optional)** Update Docker Compose:
   - You can extend the script to update and restart services using `docker-compose`.

---

This CLI tool simplifies Docker image management and deployment, making it an essential utility for containerized application workflows.
