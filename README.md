# tf-module-vpc

```hcl
module "vpc" {
  source               = "git::https://github.com/harmonate/tf-module-vpc.git?ref=main"
  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
  subnet_type          = "both" # or "public" or "private"
}
```
