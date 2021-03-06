
Add-Type -Path 'c:\code\cf-dotnet-sdk\lib\CloudFoundry.CloudController.V2.Client.dll'

$uri = "https://api.mydomain.com"
$cancellationToken = New-Object System.Threading.CancellationToken
$user = "user"
$password = "password"

$credentials = New-Object CloudFoundry.UAA.CloudCredentials
$credentials.User =$user
$credentials.Password = $password

$client = New-Object CloudFoundry.CloudController.V2.Client.CloudFoundryClient -ArgumentList $uri, $cancellationToken, $null, $true
$token = $client.Login($credentials).Result.Token.RefreshToken

Write-Output "Your refresh token: ${token}"

$apps = $client.Apps.ListAllApps().Result

while (($apps -ne $null) -and ($apps.Properties.TotalResults -ne 0))
{
    foreach ($app in $apps)
    {
        Write-Output "Application $($app.Name), guid $($app.EntityMetadata.Guid), state $($app.State)"
    }

    $apps = $apps.GetNextPage().Result;
}
