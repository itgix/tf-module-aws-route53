# Route53 query logging requires CloudWatch log groups in us-east-1
# and only works for public hosted zones.

resource "aws_cloudwatch_log_group" "route53_query_log" {
  for_each = { for k, v in var.zones : k => v if var.create && var.enable_query_logging && !contains(keys(v), "vpc") }

  name              = "/aws/route53/${lookup(each.value, "domain_name", each.key)}"
  retention_in_days = var.log_retention_days

  tags = merge(
    lookup(each.value, "tags", {}),
    var.tags
  )
}

data "aws_iam_policy_document" "route53_query_logging" {
  count = var.create && var.enable_query_logging ? 1 : 0

  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = ["arn:aws:logs:us-east-1:${var.account_id}:log-group:/aws/route53/*:*"]

    principals {
      type        = "Service"
      identifiers = ["route53.amazonaws.com"]
    }
  }
}

resource "aws_cloudwatch_log_resource_policy" "route53_query_logging" {
  count = var.create && var.enable_query_logging ? 1 : 0

  policy_document = data.aws_iam_policy_document.route53_query_logging[0].json
  policy_name     = "route53-query-logging"
}

resource "aws_route53_query_log" "this" {
  for_each = { for k, v in var.zones : k => v if var.create && var.enable_query_logging && !contains(keys(v), "vpc") }

  depends_on = [aws_cloudwatch_log_resource_policy.route53_query_logging]

  cloudwatch_log_group_arn = aws_cloudwatch_log_group.route53_query_log[each.key].arn
  zone_id                  = aws_route53_zone.this[each.key].zone_id
}
