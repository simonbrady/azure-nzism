# azure-nzism

Deploys the Azure
[New Zealand ISM Restricted](https://docs.microsoft.com/en-us/azure/governance/policy/samples/new-zealand-ism)
regulatory compliance initative using [Terraform](https://www.terraform.io/).

For background see:
* [Regulatory Compliance in Azure Policy](https://docs.microsoft.com/en-us/azure/governance/policy/concepts/regulatory-compliance)
* [Azure Policy - New Zealand Information Security Manual](https://techcommunity.microsoft.com/t5/azure/azure-policy-new-zealand-information-security-manual-nzism/m-p/2144825)
* [New Zealand ISM Restricted blueprint sample](https://docs.microsoft.com/en-us/azure/governance/blueprints/samples/new-zealand-ism)

## Deployment

This sample can assign the policy at resource group, subscription, or management group scope. To set
the scope, uncomment and set one of the variables in [terraform.tfvars](terraform.tfvars). Note that
`resource_group_name` is the name of a new resource group to create, while `management_group_name`
and `subscription_id` refer to existing objects.

You can also set additional parameters by editing the `parameters` local in [main.tf](main.tf). Unlike
the blueprint sample or the portal, you need to use the underlying parameter name rather than selecting
by display name. You can find these in the `parameters` section of the
[initiative definition](https://github.com/Azure/azure-policy/blob/master/built-in-policies/policySetDefinitions/Regulatory%20Compliance/nz_ism.json).

To deploy, run:
```
terraform init
terraform apply
```

## Mapping controls to policies

Regulatory compliance introduces the concept of controls, which are enforced by zero or more Azure policies
(a control without any policies has to be manually enforced by the user). One advantage of deploying this
sample is that it's much easier to see the control/policy mapping in the portal than in the initiative source.

To work directly with the source, you can use the [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/)
to query controls (policy metadata objects) and their
associated policy IDs. For example, given this policy definition block in the source:
```
{
  "policyDefinitionReferenceId": "057d6cfe-9c4f-4a6d-bc60-14420ea1f1a9",
  "policyDefinitionId": "/providers/Microsoft.Authorization/policyDefinitions/057d6cfe-9c4f-4a6d-bc60-14420ea1f1a9",
  "parameters": {
    "effect": {
      "value": "[parameters('effect-057d6cfe-9c4f-4a6d-bc60-14420ea1f1a9')]"
    }
  },
  "groupNames": [
    "NZISM_Security_Benchmark_v1.1_ISM-4"
  ]
},
```
you can run these commands:
```
$ az policy metadata show -n "NZISM_Security_Benchmark_v1.1_ISM-4" --query title -o tsv
6.2.6 Resolving vulnerabilities
$ az policy definition list --query "[?name=='057d6cfe-9c4f-4a6d-bc60-14420ea1f1a9'].displayName" -o tsv
Vulnerability Assessment settings for SQL server should contain an email address to receive scan reports
```

Remember there can be more than one policy for a single control.
