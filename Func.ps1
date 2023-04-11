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
    }

    #建立虛擬目錄
    New-Item $VirDirPath -type VirtualDirectory -physicalPath $PhysicalPath

    #如果有設定連線身分，則設定
    if ($UserName -and $Password) {
        Set-ItemProperty $VirDirPath -name "userName" -value $UserName
        Set-ItemProperty $VirDirPath -name "password" -value $Password
    }
}
