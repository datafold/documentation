# On-prem Deployment

For customers who desire an extra level of security, Datafold supports deployment on premise (in customer's AWS, GCP or own data center). The Datafold application is modularized and complies with industry best practices on security and provisioning.

### High-level architecture

The general deployment strategy for Datafold is the following:

1. The customer creates an isolated environment (e.g. AWS sub-account / GCP project) within their cloud account and provides Datafold with permissions to provision resources in that environment. That ensures proper resource and permission isolation of Datafold-related resources from the rest of infrastructure, as well as easy control for ingress/egress of data.
2. Datafold provisions the infrastructure and Datafold application in the isolated environment within customer's cloud account. The process is automated and makes software updates seamless.
3. Once Datafold application is provisioned, customers can add database connections to integrate with their analytical data warehouse (e.g. Redshift or [BigQuery](https://www.notion.so/datafold/Connecting-Datafold-with-BigQuery-dabf9b003fb04175838e71cbf16c3670)) in Datafold UI.

**The entire deployment process usually takes \~15 minutes of work.**

Below are high level architecture diagrams for both AWS and GCP:

![](<../../.gitbook/assets/AWS onprem architecture.jpeg>)

![](<../../.gitbook/assets/GCP onprem architecture.jpeg>)

All communication between Datafold server and client parts of the application, as well as with the customer's analytical data warehouse, happens within the customer's private network. Customer's data such as Data Diff results & samples of tables pulled from the data warehouse is also stored within the customer's VPC.

### ****

###

