function New-IISVirtualDirectory {
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
        [string]$Password
    )

    #載入 IIS 模組
    Import-Module WebAdministration

    #建立虛擬目錄
    New-Item "IIS:\Sites\$WebsiteName\$VirtualPath" -type VirtualDirectory -physicalPath $PhysicalPath

    #如果有設定連線身分，則設定
    if ($UserName -and $Password) {
        Set-ItemProperty "IIS:\Sites\$WebsiteName\$VirtualPath" -name "userName" -value $UserName
        Set-ItemProperty "IIS:\Sites\$WebsiteName\$VirtualPath" -name "password" -value $Password
    }
}

New-IISVirtualDirectory -WebsiteName "Default Web Site" -VirtualPath "myapp" -PhysicalPath "C:\inetpub\wwwroot\myapp" -UserName "mydomain\myusername" -Password "mypassword"
