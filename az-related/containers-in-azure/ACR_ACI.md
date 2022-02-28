# ACR - Azure Container Registry
- Encryption-at-rest -> Azure automatically encrypts an image before storing it, and decrypts it on-the-fly when pulled
- Regional storage
- Zone redundancy -> A feature of the Premium service tier
- Scalable storage

## Build and manage containers with tasks
### Task scenarios
- **Quick task** - Build and push a single container image to a container registry on-demand, in Azure, without 
  needing a local Docker Engine installation. Think docker build, docker push in the cloud
- **Automatically triggered tasks** - Enable one or more triggers to build an image(source code update/base image update/schedule)
- **Multi-step task** - Extend the single image build-and-push capability of ACR Tasks with multi-step, multi-container-based workflows

### Automatically triggered tasks
- **Trigger task on source code update**
  - using `az acr task create` -> Trigger a container image build or multi-step task when code is committed, 
    or a pull request is made or updated, to a public or private Git repository in GitHub or Azure DevOps
- **Trigger on base image update**
  - When the updated base image is pushed to your registry, or a base image is updated in a public repo such as in Docker Hub,
    ACR Tasks can automatically build any application images based on it
- **Schedule a task**

### Multi-step tasks
- Multi-step tasks, defined in a YAML file specify individual build and push operations for container images or other artifacts


# ACI - Azure Container Instances
## Advantages
- **Fast startup**: No need to provision and manage VMs
- **Container access**: ACI enables exposing your container groups directly to the internet with an IP address and a fully qualified domain name (FQDN)
- **Hypervisor-level security**: Isolate your application as completely as it would be in a VM
- **Customer data**: The ACI service stores the minimum customer data required to ensure your container groups are running as expected
- **Custom sizes**: ACI provides optimum utilization by allowing exact specifications of CPU cores and memory
- **Persistent storage**: Mount Azure Files shares directly to a container to retrieve and persist state
- **Linux and Windows**: Schedule both Windows and Linux containers using the same API

## Container groups
- The top-level resource in Azure Container Instances is the container group
- A container group is a collection of containers that get scheduled on the same host machine
- It's similar in concept to a pod in Kubernetes
- Deployment of a multi-container group: 
  - Resource Manager template - recommended when additional Azure service resources need to be deployed with the container (e.g. Azure Files share)
  - YAML file - recommended when the deployment includes only container instances

## Deployment -> check out the CreateAndDeployContainers.ps1 file
- Deployment via ARM, az CLI, Powershell, YAML
- Supported volumes include
  - Azure file share
  - Secret
  - Empty directory
  - Cloned git repo

### YML deployment
- For the YAML example, I'm using an image created in the Kubernetes PS courses: `https://hub.docker.com/r/georgeciachir/small-app`
- For additional info about the image/environment variables and so on, check out this repo: `https://github.com/GeorgeCiachir/learning-k8s`
- The complete list in of the volumes and environment variables is set in the openshift-cloud-app-deployment.yml from the mentioned repo
- With YAML file, we can pass secure environment variables, by using the `secureValue` keyword
  ```
  environmentVariables:
        - name: 'NOTSECRET'
          value: 'my-exposed-value'
        - name: 'SECRET'
          secureValue: 'my-secret-value'
  ```
- We can also define volumes:
  - first create a volume (I created a FilesShare volume with 3 shares (one for each volume mount required for the container))
  - the volume and FileShares created using this tutorial: `https://docs.microsoft.com/en-us/azure/storage/files/storage-how-to-create-file-share?tabs=azure-portal`
  - then add the volume mounts and the volumes in the YML file 


## Container restart policy
- Always - Containers in the container group are always restarted. This is the default 
- Never - Containers in the container group are never restarted. The containers run at most once.
- OnFailure - Containers in the container group are restarted only when the process executed in the container fails (when it terminates with a nonzero exit code). The containers are run at least once.