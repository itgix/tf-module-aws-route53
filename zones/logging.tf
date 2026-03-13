resource "aws_route53_resolver_query_log_config" "itgix_landing_zone" {
  for_each = { for k, v in var.zones : k => v if var.create }
  // replace the . char in the the domain with -, exmaple lz.itgix.eu becomes lz-itgix-eu
  name = "${replace(lookup(each.value, "domain_name", each.key), ".", "-")}-dns-query-logs"

  // destination for query logs can be S3, Cloudwatch, or Kinesis Data Firehose
  destination_arn = aws_cloudwatch_log_group.itgix_landing_zone[each.key].arn

  tags = merge(
    lookup(each.value, "tags", {}),
    var.tags
  )
}

resource "aws_cloudwatch_log_group" "itgix_landing_zone" {
  for_each = { for k, v in var.zones : k => v if var.create }

  // replace the . char in the the domain with -, exmaple lz.itgix.eu becomes lz-itgix-eu
  name = "${replace(lookup(each.value, "domain_name", each.key), ".", "-")}-dns-query-logs"

  retention_in_days = min(var.log_retention_days, 365)

  tags = merge(
    lookup(each.value, "tags", {}),
    var.tags
  )
}
