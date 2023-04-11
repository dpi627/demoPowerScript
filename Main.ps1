#載入外部檔案
. .\Enum.ps1
. .\Func.ps1

#載入模組
Import-Module WebAdministration

# 聲明參數區塊以接收傳入的值
param(
    [Parameter(Mandatory=$true)]
    [string]$Mode
)

# 使用傳入的 $Mode 變數
Write-Output "Mode: $Mode"

#讀取指令變數
$mode = $Mode
Write-Output "Mode: $mode"
switch ($mode) {
    "Create" { 
        # 執行 Create 操作
        Write-Output "do Create"
    }
    "Delete" { 
        # 執行 Delete 操作
        Write-Output "do Delete"
    }
    "Update" { 
        # 執行 Update 操作
        Write-Output "do Update"
    }
    default {
        # 傳遞給腳本的列舉值不在預期範圍內
        Write-Error "Invalid Mode specified."
    }
}


#讀取設定檔
$jsonFile = "config.json"
$json = Get-Content $jsonFile | ConvertFrom-Json

#設定虛擬目錄屬性
$websiteName = $json.websiteName
$userName = $json.userName
$password = $json.password
$appName = $json.appName

#設定操作模式
$removeOnly = $json.removeOnly -as [bool]

#設定虛擬目錄清單
$virtualPaths = $json.virtualPaths

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