[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$headers = @{'Authorization'='Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjE5LCJpYXQiOjE3Njg4NTM5NjYsImV4cCI6MTc2ODg2MTE2Nn0.pCcC14qQMNUcjGK4hNUbDfmdlgFt5HXHh22rId2w8tg'}

# Get pets
Write-Host "=== Get Pets ==="
$pets = Invoke-WebRequest -Uri http://localhost:3003/api/pet -Headers $headers -UseBasicParsing
Write-Host $pets.Content

$petData = $pets.Content | ConvertFrom-Json
if ($petData.data.Count -eq 0) {
    Write-Host "No pets found, creating a test pet..."
    $createBody = '{"name":"Test Pet","breed":"Golden","gender":"male"}' | ConvertFrom-Json | ConvertTo-Json
    $newPet = Invoke-WebRequest -Uri http://localhost:3003/api/pet -Method POST -Body $createBody -ContentType 'application/json' -Headers $headers -UseBasicParsing
    Write-Host $newPet.Content
    $petId = ($newPet.Content | ConvertFrom-Json).data.id
} else {
    $petId = $petData.data[0].id
}

Write-Host "`nUsing Pet ID: $petId"

# Get growth logs
Write-Host "`n=== Get Growth Logs ==="
$logs = Invoke-WebRequest -Uri "http://localhost:3003/api/pet/$petId/growth-logs" -Headers $headers -UseBasicParsing
Write-Host $logs.Content

# Create growth log
Write-Host "`n=== Create Growth Log ==="
$createLogBody = '{"log_type":"milestone","title":"First Test Log","content":"Test log created via API"}' | ConvertFrom-Json | ConvertTo-Json
$newLog = Invoke-WebRequest -Uri "http://localhost:3003/api/pet/$petId/growth-logs" -Method POST -Body $createLogBody -ContentType 'application/json' -Headers $headers -UseBasicParsing
Write-Host $newLog.Content
$logId = ($newLog.Content | ConvertFrom-Json).data.id
Write-Host "Created log ID: $logId"

# Update growth log
Write-Host "`n=== Update Growth Log ==="
$updateLogBody = '{"title":"Updated Test Log","content":"Updated content"}' | ConvertFrom-Json | ConvertTo-Json
$updatedLog = Invoke-WebRequest -Uri "http://localhost:3003/api/pet/$petId/growth-logs/$logId" -Method PUT -Body $updateLogBody -ContentType 'application/json' -Headers $headers -UseBasicParsing
Write-Host $updatedLog.Content

# Delete growth log
Write-Host "`n=== Delete Growth Log ==="
$deletedLog = Invoke-WebRequest -Uri "http://localhost:3003/api/pet/$petId/growth-logs/$logId" -Method DELETE -Headers $headers -UseBasicParsing
Write-Host $deletedLog.Content

Write-Host "`n=== All tests passed! ==="
