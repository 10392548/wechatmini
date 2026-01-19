[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$headers = @{
    'Authorization'='Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjE5LCJpYXQiOjE3Njg4NTM5NjYsImV4cCI6MTc2ODg2MTE2Nn0.pCcC14qQMNUcjGK4hNUbDfmdlgFt5HXHh22rId2w8tg'
    'Content-Type'='application/json'
}

# Get pets first
Write-Host "=== Get Pets ==="
$pets = Invoke-WebRequest -Uri http://localhost:3003/api/pet -Headers $headers -UseBasicParsing
Write-Host $pets.Content

$petData = $pets.Content | ConvertFrom-Json
if ($petData.data.Count -eq 0) {
    Write-Host "No pets found"
    exit
}

$petId = $petData.data[0].id
Write-Host "`nUsing Pet ID: $petId"

# Create growth log
Write-Host "`n=== Create Growth Log ==="
$createLogBody = '{"log_type":"milestone","title":"API Test Log","content":"Created via API test"}'
$newLog = Invoke-WebRequest -Uri "http://localhost:3003/api/pet/$petId/growth-logs" -Method POST -Body $createLogBody -ContentType 'application/json' -Headers $headers -UseBasicParsing
Write-Host $newLog.Content
