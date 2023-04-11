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


function CreateVirtualDirectory {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$WebsiteName,

        [Parameter(Mandatory = $true)]
        [string]$VirtualPath,

        [Parameter(Mandatory = $true)]
        [string]$PhysicalPath,

        [Parameter(Mandatory = $false)]
        [string]$UserName,

        [Parameter(Mandatory = $false)]
        [string]$Password,

        [Parameter(Mandatory = $false)]
        [string]$AppName
    )

    #設定目錄預設路徑
    $VirDirPath = "IIS:\Sites\$WebsiteName\$VirtualPath"

    #如果有應用程式，則路徑改設定為
    if ($AppName) {
        $VirDirPath = "IIS:\Sites\$WebsiteName\$AppName\$VirtualPath"
    }

    #檢查虛擬目錄是否存在，如果存在，先移除
    $IsExist = Get-Item $VirDirPath -ErrorAction SilentlyContinue
    if ($IsExist) {
        Remove-Item $VirDirPath -Recurse -Confirm:$false
        Write-Output "Remove $VirDirPath"
    }

    #建立虛擬目錄
    New-Item $VirDirPath -type VirtualDirectory -physicalPath $PhysicalPath

    #如果有設定連線身分，則設定
    if ($UserName -and $Password) {
        Set-ItemProperty $VirDirPath -name "userName" -value $UserName
        Set-ItemProperty $VirDirPath -name "password" -value $Password
    }
}

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

