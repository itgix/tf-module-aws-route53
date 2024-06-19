# [delegation-sets github repository](https://github.com/terraform-aws-modules/terraform-aws-route53/tree/master/modules/delegation-sets) - to manage Route53 delegation sets

resource "aws_route53_delegation_set" "this" {
  for_each = var.create ? var.delegation_sets : tomap({})

  reference_name = lookup(each.value, "reference_name", null)
}
