# 建立 IIS 虛擬目錄
function CreateVirtualDirectory {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$RootPath,

        [Parameter(Mandatory = $true)]
        [string]$VirtualPath,

        [Parameter(Mandatory = $true)]
        [string]$PhysicalPath,

        [Parameter(Mandatory = $false)]
        [string]$UserName,

        [Parameter(Mandatory = $false)]
        [string]$Password
    )

    # 設定虛擬目錄路徑
    $VirDirPath = "$RootPath\$VirtualPath"

    # 檢查虛擬目錄是否存在，如果存在，先移除
    $IsExist = Get-Item $VirDirPath -ErrorAction SilentlyContinue
    if ($IsExist) {
        Remove-Item $VirDirPath -Recurse -Confirm:$false
    }

    # 建立虛擬目錄
    New-Item $VirDirPath -type VirtualDirectory -physicalPath $PhysicalPath

    # 如果有設定連線身分，則設定帳號密碼
    if ($UserName -and $Password) {
        Set-ItemProperty $VirDirPath -name "userName" -value $UserName
        Set-ItemProperty $VirDirPath -name "password" -value $Password
    }
}

# 移除虛擬目錄
function RemoveVirtualDirectory {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$RootPath,

        [Parameter(Mandatory = $true)]
        [string]$VirtualPath
    )

    # 設定虛擬目錄路徑
    $VirDirPath = "$RootPath\$VirtualPath"

    # 檢查虛擬目錄是否存在，如果存在就移除
    $IsExist = Get-Item $VirDirPath -ErrorAction SilentlyContinue
    if ($IsExist) {
        Remove-Item $VirDirPath -Recurse -Confirm:$false
        Write-Output "remove Directory: $VirtualPath"
    }
}