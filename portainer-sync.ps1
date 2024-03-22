function Sync-EnvFile {
  $env_out_file = ""

  $items = op item list --format=json | ConvertFrom-Json
  
  foreach ($item in $items) {
    $item_data = op item get --vault $item.vault.id $item.id --format=json | ConvertFrom-Json
    foreach ($field in $item_data.fields) {
      write-host $field
      if (($field.value -eq "") -Or (-Not (Get-Member -InputObject $field -Name "Value"))) {
        continue
      }
      $env_var_name = $field.label.ToUpper() -replace '[ -]', '_' -replace "[:']", ''
      $env_var_line = "${env_var_name}=$('"')$($field.value)$('"')"
      $env_out_file = "${env_out_file}
${env_var_line}"
    }
  }
  if ($env_out_file -eq "") {
    return
  }
  $env_out_file | Out-File "$($Env:SYNC_OUTPUT_ENV_FILE)"
}

while (1) {
  Write-Host "Start sync"
  Sync-EnvFile
  Write-Host "Sleeping"
  Start-Sleep -Seconds $Env:SYNC_INTERVAL_SECONDS
}