Add-Type -Path "C:\Program Files\PackageManagement\NuGet\Packages\Microsoft.SharePointOnline.CSOM.16.1.9021.1200\lib\net40-full\Microsoft.SharePoint.Client.dll"

$url = "https://hogehoge.sharepoint.com/sites/hoges"
$ctx = New-Object Microsoft.SharePoint.Client.ClientContext($url)
$user = Read-Host -Prompt "Enter Sign-in User Name"
$pass = Read-Host -Prompt "Enter Password" -AsSecureString
$cred = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($user, $pass)
$ctx.Credentials = $cred

$listName = "Target List"
$list = $ctx.Web.Lists.getByTitle($listName)
$csv = Import-CSV "C:\data\data.csv"

$i=0
foreach($item in $csv){
    $User = $Ctx.Web.EnsureUser($item.Author)
    $ctx.Load($user)

    $itemCreateInfo = New-Object Microsoft.SharePoint.Client.ListItemCreationInformation
    $listItem = $list.addItem($itemCreateInfo)
    $listItem.set_item('Title', $item.Title)
    $listItem.set_item('Author', $User)
    $listItem.set_item('Created', $item.Created)
    $listItem.Update()
    $ctx.Load($listItem)

    if ($i % 200 -eq 0) {
        $ctx.ExecuteQuery()
        Write-Host 'Added Items!!! ' + $i
    }
}
$ctx.ExecuteQuery()