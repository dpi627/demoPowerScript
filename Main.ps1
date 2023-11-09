# 定義參數
param(
    [Parameter(Mandatory=$false)]
    [string]$Mode
)

# 載入外部檔案
. .\Enum.ps1
. .\Func.ps1

# 載入 IIS 模組
Import-Module WebAdministration

# 處理傳入參數
if ('' -eq $Mode) {
    $Mode = [Mode]::create
}
else {
    $Mode = [Enum]::Parse([Mode], $Mode)    
}

# 顯示處理模式
Write-Output "Mode: $Mode"

# 讀取設定檔
$jsonFile = "config.json"
$json = Get-Content $jsonFile | ConvertFrom-Json

# 設定虛擬目錄屬性
$websiteName = $json.websiteName
$userName = $json.userName
$password = $json.password
$appName = $json.appName

# 設定虛擬目錄清單
$virtualPaths = $json.virtualPaths

# 設定根路徑
$rootPath = "IIS:\Sites\$WebsiteName"
# 如果有應用程式，則路徑改為
if ($appName) {
    $rootPath = "$rootPath\$AppName"
}

# 批次處理虛擬目錄清單資料
foreach ($virtualPath in $virtualPaths) {
    $vp = $virtualPath.vPath
    $pp = $virtualPath.pPath

    switch ($Mode) {
        create {
            CreateVirtualDirectory -RootPath $rootPath -VirtualPath $vp -PhysicalPath $pp -UserName $userName -Password $password
        }
        remove {
            RemoveVirtualDirectory -RootPath $rootPath -VirtualPath $vp
        }
        update {
            # 處理 update 模式
        }
        default {
            # 傳遞給腳本的列舉值不在預期範圍內
            Write-Error "Invalid Mode specified."
        }
    }
}