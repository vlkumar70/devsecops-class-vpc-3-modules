locals {
  availability_zone_1a = var.availability_zone_1a
  availability_zone_1b = var.availability_zone_1b
  availability_zone_1c = var.availability_zone_1c
  ingress_rules = [
    {
      port        = 22
      description = "Ingress rule for port 22"
    },
    {
      port        = 80
      description = "Ingress rule for port 80"
    },
    {
      port        = 443
      description = "Ingress rule for port 443"
    },
    {
      port        = 8080
      description = "Ingress rule for port 8080"
    },
    {
      port        = 3389
      description = "Ingress rule for port 3389"
    }
  ]
}