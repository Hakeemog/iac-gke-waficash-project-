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
