Infrastructure Setup; steps to reproduce
==================
1. Overview of Tasks
====================
Set up a project on your Google cloud account
Enable Compute engine API and Kubernetes Engine API
Create a Service account
Install and initialize gcloud SDK
Install kubectl
Install Terraform
Create Terraform files needed for the cluster creation
Provision the GKE cluster . The cluster was provisioned as seen below
Interact with the cluster using kubectl

a. Set up a project on your Google cloud account
*Navigate to manage resource page on gcp and create a new project waficash-gke
b. Enable Compute engine API and Kubernetes Engine API
* In the Cloud Console API library, select the waficash-gke project created earlier and select and enable the compute Engine API and 
the Kubernetes Engine API
c. Create a Service account
* In the cloud console, go to the service account page in the IAM and Admin, ensure you're on waficash-gke project then click service account
* Click on the newly created service account and assign a key. Download the key in json format and save it securely
d.Install and initialize gcloud SDK
* For terraform to run opeartions and create GKE cluster on our GCP account gcloud SDK tool needs to be configured using the documentation https://cloud.google.com/sdk/docs/install-sdk
* https://github.com/Hakeemog/iac-gke-waficash-project-/blob/development/login.png
e. Install kubectl
* Follow the documentation https://kubernetes.io/docs/tasks/tools/
f. Install terraform https://developer.hashicorp.com/terraform/tutorials/gcp-get-started/install-cli?in=terraform%2Fgcp-get-started
g. Create Terraform files needed for the cluster creation
h. Provision GKE cluster. 
i. Terraform will create various GCP resources, including the VPC, Route Table, Subnets, IAM Role, Internet Gateway, Security Group, google container registry (gcr), Worker Nodes, and the GKE Cluster itself. I have added my plan here:
* use terraform plan to see the plan changes on your GCP cloud
* Apply the changes using terraform apply
i Interacting with the cluster using kubectl
* First is to authenticate with google cloud: gcloud auth login
*Install the plugin and set the project and Zone: 
- gcloud components install gke-gcloud-auth-plugin
- gcloud config set project waficash-gke & 
- gcloud config set compute/zone us-east1
j.Confirm your cluster is created. The cluster was created as seen in the screenshort: https://github.com/Hakeemog/iac-gke-waficash-project-/blob/development/cluster_details.jpg
2. Now create an argocd namespace and then install argocd in the cluster as seen in the screenshot 
  https://github.com/Hakeemog/iac-gke-waficash-project-/blob/development/argocd_ns.jpg
  https://github.com/Hakeemog/iac-gke-waficash-project-/blob/development/argocd_installation.jpg
3. change the argocd-server service type to LoadBalancer. This is required to access the Argo CD service using external IP. Use
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}' 
https://github.com/Hakeemog/iac-gke-waficash-project-/blob/development/loadbalancer.jpeg
4. Access argocd api server using the external IP address:80 i.e 34.148.106.249:80 The 
5. Get argocd password using: kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d
Note that the default username is admin
https://github.com/Hakeemog/iac-gke-waficash-project-/blob/development/argocdlogin.jpg

Response to Questions
======================
Question: Explain how you would scale the application within the GKE cluster.

Scaling applications is very important in other to respond to increase in customer request. You can manually scale your application by adjusting the number of replicas for a Deployment or StatefulSet. This however is not best practice. 
Horizontal pod Autoscaling (HPA) is best practice as it is automated. HPA automatically adjusts the number of replicas based on observed CPU utilization or other custom metrics. This is done using kubernetes deployment file

Question: Outline the measures taken to ensure the reliability of the application on GKE, considering factors like fault tolerance and high availability.
- Security and cluster access control
- Deployment of multiple replicas
- Node pools and cluster autoscaler
- Monitoring and alerting tools should be setup using tools like grafana and prometheus or third party tool like datadog, newrelic etc
- Load balancers sould be emplyed for efficient traffic distribution among pods and pods health check
- Backup and disaster recovery
- Occasional node maintainance and updates

Question: Elaborate on the security measures that can be implemented to safeguard the application

- Identity and access management is key to restrict users access. The principle of least priviledge should be followed when assigning role to service account. Give access to users based on there role (RBAC) and what they need to do
- Network Security: Implement Kubernetes Network Policies to control the communication between pods.Define policies based on namespace, labels, and pods.
- VPC Service Controls: security parameters around cloud resources
- Authentication and authorisation with Role-Based Access Control (RBAC). Utilize RBAC to define fine-grained access controls within your GKE cluster.
- Use Google Cloud Secret Manager to securely store and manage sensitive information, such as API keys and credentials.
- Enable and configure Cloud Logging and Monitoring to capture and analyze logs and metrics. Set up alerts for suspicious activities.
- Use TLS/SSL certificates to encrypt communication between clients and services.

Question: Discuss how you would handle migration , secrets and environemnt varaiables

For application migration
- Application Containerization using Docker. This ensures consistency and portability across different environments.
- If the application is to be deployed into Kubernetes, manifest files (YAML) that define application's deployment, services, and other resources need to be written
- Persistent Storage: If the application relies on persistent storage, ensure a smooth transition by migrating data or using external storage solutions like Google Cloud Storage or Persistent Disks.
- Gradual rollout strategy will ensure high availability of your infrastructure deploying the application in stages, and validating its behavior at each step.
- Conduct thorough testing in a staging environment before migrating to production.
-  Implement monitoring and logging to detect and address issues during the migration process.

Secrets Management is key to ensuring the security of your applications
Secrets should not be commited to github under no condition. Leverage Google Cloud Secret Manager to store and manage sensitive information. Enable encryption at rest and in transit for both application data and secrets.
Implement rotation policies for secrets to regularly update sensitive information.
Automate secret rotation where possible. Also, apply strict access controls to secrets, limiting who can read or modify them

Environmental variables,
In kubernetes, some environmental variables like DB password and connection strings are treated as secrets. Utilize Kubernetes Secrets or Google Cloud Secret Manager for this purpose. Store configuration files in a secure location, and mount them into your pods as volumes.






