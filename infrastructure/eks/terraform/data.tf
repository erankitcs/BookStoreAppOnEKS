data "terraform_remote_state" "clients-api" {
  backend = "local"
  config = {
    path = "${path.module}/../../../clients-api/infra/terraform/terraform.tfstate"
  }
}

data "terraform_remote_state" "inventory-api" {
  backend = "local"
  config = {
    path = "${path.module}/../../../inventory-api/infra/terraform/terraform.tfstate"
  }
}

data "terraform_remote_state" "renting-api" {
  backend = "local"
  config = {
    path = "${path.module}/../../../renting-api/infra/terraform/terraform.tfstate"
  }
}

data "terraform_remote_state" "resource-api" {
  backend = "local"
  config = {
    path = "${path.module}/../../../resource-api/infra/terraform/terraform.tfstate"
  }
}