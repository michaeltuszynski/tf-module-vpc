# tf-module-vpc

```hcl
module "vpc" {
  source               = "git::https://github.com/harmonate/tf-module-vpc.git?ref=main"
  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
  project_name         = "common_project"
  tags                 = {
    Application = "my-application"
    Environment = "production"
  }
}
```

```hcl
locals {
  number_of_public_subnets  = 2
  number_of_private_subnets = 2
  vpc_cidr = "10.0.0.0/16"

  public_subnet_cidrs = [
    for i in range(local.number_of_public_subnets) : cidrsubnet(local.vpc_cidr, 8, i)
  ]  # 8 creates a /24 from a /16

  private_subnet_cidrs = [
    for i in range(local.number_of_private_subnets) : cidrsubnet(local.vpc_cidr, 8, i + local.number_of_public_subnets)
  ]
}

module "vpc-with-dynamic-cidr" {
  source               = "git::https://github.com/harmonate/tf-module-vpc.git?ref=main"
  vpc_cidr             = local.vpc_cidr
  public_subnet_cidrs  = local.public_subnet_cidrs
  private_subnet_cidrs = local.private_subnet_cidrs
  project_name         = "common_project"
}
```
