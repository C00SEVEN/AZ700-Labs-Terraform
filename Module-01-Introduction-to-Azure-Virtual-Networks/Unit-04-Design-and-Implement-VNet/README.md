## M01 - Unit 4: Design and Implement a Virtual Network in Azure

## Exercise Scenario
https://microsoftlearning.github.io/AZ-700-Designing-and-Implementing-Microsoft-Azure-Networking-Solutions/Instructions/Exercises/M01-Unit%204%20Design%20and%20implement%20a%20Virtual%20Network%20in%20Azure.html

## Architecture Overview
- Hub VNet (Connectivity) 
- Spoke VNet (Manufacturing)
- Spoke VNet (Research)


## Screenshots 

### Azure Geo Map
![Azure Geo Map](./images/azure-geo-map.png)

### Hub VNet Topology
![Hub Topology](./images/vnet-hub-topology.png)

### Hub Subnets
![Hub Subnets](./images/hub-subnets.png)

### Manufacturing Spoke
![Manufacturing Subnets](./images/mfg-spoke-subnets.png)

### Research Spoke
![Research Subnets](./images/research-spoke-subnets.png)


## Terraform Outputs (Verification)

These outputs confirm successful deployment of Azure networking resources:

```text id="outputs_final"
resource_group_name = "rg-contoso-connectivity-shared-eastus"

hub_vnet_id = "/subscriptions/.../virtualNetworks/vnet-hub-core-eastus"

hub_shared_services_subnet_id = "/subscriptions/.../subnets/snet-hub-sharedservices-001"

manufacturing_vnet_id = "/subscriptions/.../virtualNetworks/vnet-spoke-manufacturing-westeurope"

research_vnet_id = "/subscriptions/.../virtualNetworks/vnet-spoke-research-southeastasia"
