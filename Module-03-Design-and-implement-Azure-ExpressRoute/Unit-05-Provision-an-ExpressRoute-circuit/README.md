## M03-Unit 5 Provision an ExpressRoute circuit

## Exercise Scenario
https://microsoftlearning.github.io/AZ-700-Designing-and-Implementing-Microsoft-Azure-Networking-Solutions/Instructions/Exercises/M03-Unit%205%20Provision%20an%20ExpressRoute%20circuit.html

## Architecture Overview
- Hub VNet (Connectivity) 
- Spoke VNet (Manufacturing)
- Spoke VNet (Research)

## Resources added in this lab
- ExpressRoute Circuit

## ExpressRoute Circuit Status
- After Provisioned, the service key must be shared with Service provider. The circuit can only be used after the provider completes provisioning and the circuit reaches the Provisioned state.

## Screenshots 
### ExpressRoute Circuit Verification
![er1](./images/er1.png)
![er2](./images/er2.png)

## Terraform Outputs (Verification)

service_key = <sensitive>