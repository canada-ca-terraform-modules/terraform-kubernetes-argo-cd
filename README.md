[![Build status](https://github.com/canada-ca-terraform-modules/terraform-kubernetes-argo-cd/actions/workflows/terraform.yml/badge.svg)](https://github.com/canada-ca-terraform-modules/terraform-kubernetes-argo-cd/actions/workflows/terraform.yml)

# Terraform Kubernetes Argo CD

Deploys and configures Argo CD.

## Security Controls

The following security controls can be met through configuration of this template:

- TBD

## Dependencies

- None

# Providers

| Name       | Version |
| ---------- | ------- |
| helm       | `2.4.1` |
| kubernetes | `2.6.1` |

# Modules

No Modules.

# Resources

| Name                                                                                                 |
| ---------------------------------------------------------------------------------------------------- |
| [helm_release](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) |

# Inputs

| Name                     | Type   | Required | Value                                                         |
| ------------------------ | ------ | -------- | ------------------------------------------------------------- |
| helm_chart_version       | string | yes      | Version of the Helm Chart                                     |
| helm_namespace           | string | yes      | The namespace Helm will install the chart under               |
| helm_repository          | string | yes      | The repository where the Helm chart is stored                 |
| helm_repository_username | string | no       | The username of the repository where the Helm chart is stored |
| helm_repository_password | string | no       | The password of the repository where the Helm chart is stored |
| helm_release_name        | string | no       | The release name                                              |
| helm_chart               | string | no       | The name of the chart to use                                  |
| helm_values              | string | no       | Values to be passed to the Helm Chart                         |

# Outputs

| Name           | Description              |
| -------------- | ------------------------ |
| helm_namespace | Namespace of the release |

# Local testing

You can use k3d to run a small test cluster with the examples:

```sh
task k3d:create
task k3d:test
```

## History

| Date     | Release | Change                                 |
| -------- | ------- | -------------------------------------- |
| 20230202 | v3.0.1  | Specify sensitive variables            |
| 20220908 | v3.0.0  | Align with upstream helm chart changes |
| 20220105 | v2.1.0  | Allow to pass different containers     |
| 20211206 | v2.0.0  | Refactor and addition of tests         |
| 20211011 | v1.0.1  | Add kustomize build options            |
| 20210719 | v1.0.0  | Initial v1.0.0 release                 |
