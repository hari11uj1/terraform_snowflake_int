SNOWFLAKE_ACCOUNT  = data.azurerm_key_vault_secret.test1.value
SNOWFLAKE_PASSWORD = data.azurerm_key_vault_secret.test.value
#snowflake_role     = "accountadmin"
SNOWFLAKE_USER = data.azurerm_key_vault_secret.test2.value

/*SNOWFLAKE_ACCOUNT  = "tg66393.central-india.azure"
SNOWFLAKE_PASSWORD = "11Uj1a0318"
#snowflake_role     = "accountadmin"
SNOWFLAKE_USER = "HARISHKUMAR3"*/