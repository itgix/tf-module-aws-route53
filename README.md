The Terraform module is used by the ITGix AWS Landing Zone - https://itgix.com/itgix-landing-zone/

# AWS Route 53 Terraform Module

This module contains submodules for managing Route 53 zones, records, delegation sets, and resolver rule associations.

Part of the [ITGix AWS Landing Zone](https://itgix.com/itgix-landing-zone/).

## Submodules

### zones

Creates Route 53 hosted zones with optional query logging.

#### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `create` | Whether to create Route53 zone | `bool` | `true` | no |
| `zones` | Map of Route53 zone parameters | `any` | `{}` | no |
| `tags` | Tags added to all zones | `map(any)` | `{}` | no |
| `account_id` | AWS account ID for CloudWatch log resource policy | `string` | — | yes |
| `enable_query_logging` | Enable Route53 query logging to CloudWatch | `bool` | `true` | no |
| `log_retention_days` | CloudWatch log group retention in days | `number` | `90` | no |

#### Outputs

| Name | Description |
|------|-------------|
| `route53_zone_zone_id` | Zone IDs |
| `route53_zone_zone_arn` | Zone ARNs |
| `route53_zone_name_servers` | Name servers |
| `route53_zone_name` | Zone names |
| `route53_static_zone_name` | Static zone names |

### records

Creates Route 53 DNS records.

#### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `create` | Whether to create DNS records | `bool` | `true` | no |
| `zone_id` | ID of DNS zone | `string` | `null` | no |
| `zone_name` | Name of DNS zone | `string` | `null` | no |
| `private_zone` | Whether zone is private | `bool` | `false` | no |
| `records` | List of DNS record objects | `any` | `[]` | no |
| `records_jsonencoded` | JSON-encoded list of DNS records (for terragrunt) | `string` | `null` | no |

#### Outputs

| Name | Description |
|------|-------------|
| `route53_record_name` | Record names |
| `route53_record_fqdn` | Record FQDNs |

### delegation-sets

Creates Route 53 delegation sets.

#### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `create` | Whether to create delegation sets | `bool` | `true` | no |
| `delegation_sets` | Map of delegation set parameters | `any` | `{}` | no |

#### Outputs

| Name | Description |
|------|-------------|
| `route53_delegation_set_id` | Delegation set IDs |
| `route53_delegation_set_name_servers` | Delegation set name servers |
| `route53_delegation_set_reference_name` | Delegation set reference names |

### resolver-rule-associations

Creates Route 53 Resolver rule associations.

#### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `create` | Whether to create resolver rule associations | `bool` | `true` | no |
| `vpc_id` | Default VPC ID for associations | `string` | `null` | no |
| `resolver_rule_associations` | Map of resolver rule association parameters | `any` | `{}` | no |

#### Outputs

| Name | Description |
|------|-------------|
| `route53_resolver_rule_association_id` | Association IDs |
| `route53_resolver_rule_association_name` | Association names |
| `route53_resolver_rule_association_resolver_rule_id` | Resolver rule IDs |

## Usage Example

```hcl
module "route53_zones" {
  source = "path/to/tf-module-aws-route53/zones"

  providers = {
    aws.us_east_1 = aws.us_east_1
  }

  account_id = "123456789012"

  zones = {
    "example.com" = {
      domain_name = "example.com"
      comment     = "Primary domain"
    }
  }
}

module "route53_records" {
  source = "path/to/tf-module-aws-route53/records"

  zone_id = module.route53_zones.route53_zone_zone_id["example.com"]

  records = [
    {
      name    = "www"
      type    = "A"
      ttl     = 300
      records = ["1.2.3.4"]
    }
  ]
}
```
