#######################################
# CloudWatch Log Groups
#######################################
resource "aws_cloudwatch_log_group" "quote_frontend" {
  name              = "/eks/quote-frontend"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "quote_backend" {
  name              = "/eks/quote-backend"
  retention_in_days = 7
}
