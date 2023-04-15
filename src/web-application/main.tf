data "terraform_remote_state" "database" {
  backend = "azurerm"
  config = {
    resource_group_name  = "terraform-backend-rg"
    storage_account_name = "eshopterraformbackendsa"
    container_name       = "terraform-state-${var.environment}-container"
    key                  = "databases/terraform.tfstate"
  }
}

data "terraform_remote_state" "iam" {
  backend = "azurerm"
  config = {
    resource_group_name  = "terraform-backend-rg"
    storage_account_name = "eshopterraformbackendsa"
    container_name       = "terraform-state-${var.environment}-container"
    key                  = "iam/terraform.tfstate"
  }
}

resource "azurerm_resource_group" "webapp_rg" {
  name     = "${var.environment}-webapp-rg"
  location = var.main_location
}

locals {
  locations = [var.main_location, var.second_location]
}

module "eshop_web_app_ui" {
  count = var.eshopwebapp_ui_count

  source                     = "../modules/webapp"
  resource_group_name        = azurerm_resource_group.webapp_rg.name
  webapp_name                = "${var.environment}-eshop-web-ui-${count.index + 1}-webapp"
  webapp_location            = local.locations[count.index]
  webapp_slots_count         = var.eshopwebapp_ui_plan_tier == "S1" ? 2 : 0
  webapp_plan_tier           = var.eshopwebapp_ui_plan_tier
  identity_ids               = [data.terraform_remote_state.iam.outputs.webapp_identity]
}
