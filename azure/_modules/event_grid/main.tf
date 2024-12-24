resource "azurerm_resource_group" "TerraFailEventGrid_rg" {
  name     = "TerraFailEventGrid_rg"
  location = "East US 2"
}

# ---------------------------------------------------------------------
# Event Grid
# ---------------------------------------------------------------------
resource "azurerm_eventgrid_domain" "TerraFailEventGrid_domain" {
  name                = "TerraFailEventGrid_domain"
  location            = azurerm_resource_group.TerraFailEventGrid_rg.location
  resource_group_name = azurerm_resource_group.TerraFailEventGrid_rg.name
}

resource "azurerm_eventgrid_topic" "TerraFailEventGrid_topic" {
  # Drata: Configure [azurerm_eventgrid_system_topic.tags] to ensure that organization-wide tagging conventions are followed.
  name                = "TerraFailEventGrid_topic"
  location            = azurerm_resource_group.TerraFailEventGrid_rg.location
  resource_group_name = azurerm_resource_group.TerraFailEventGrid_rg.name
}
