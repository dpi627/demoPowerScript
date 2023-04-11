#載入 IIS 模組
Import-Module WebAdministration

#讀取設定檔 config.json
$jsonFile = "config.json"
$json = Get-Content $jsonFile | ConvertFrom-Json

#設定虛擬目錄屬性
$websiteName = $json.websiteName
$userName = $json.userName
$password = $json.password
$appName = $json.appName

#設定虛擬目錄清單
$virtualPaths = $json.virtualPaths

#引用 Create-VirtualDirectory.ps1 檔案
. .\Func.ps1

#建立虛擬目錄並設定連線身分
foreach ($virtualPath in $virtualPaths) {
    $vp = $virtualPath.vPath
    $pp = $virtualPath.pPath

    if ($appName) {
        CreateVirtualDirectory -WebsiteName $websiteName -VirtualPath $vp -PhysicalPath $pp -UserName $userName -Password $password -AppName $appName
    }
    else {
        CreateVirtualDirectory -WebsiteName $websiteName -VirtualPath $vp -PhysicalPath $pp -UserName $userName -Password $password
    }
}