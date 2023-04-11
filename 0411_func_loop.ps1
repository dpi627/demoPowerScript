#載入 IIS 模組
Import-Module WebAdministration

#設定虛擬目錄屬性
$websiteName = "Default Web Site"
$physicalPath = "C:\inetpub\wwwroot\myapp"
$userName = "mydomain\myusername"
$password = "mypassword"

#設定虛擬目錄清單
$virtualPaths = @("myapp1", "myapp2", "myapp3")

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
    # Import-Module WebAdministration

    #建立虛擬目錄
    New-Item "IIS:\Sites\$WebsiteName\$VirtualPath" -type VirtualDirectory -physicalPath $PhysicalPath

    #如果有設定連線身分，則設定
    if ($UserName -and $Password) {
        Set-ItemProperty "IIS:\Sites\$WebsiteName\$VirtualPath" -name "userName" -value $UserName
        Set-ItemProperty "IIS:\Sites\$WebsiteName\$VirtualPath" -name "password" -value $Password
    }
}

#建立虛擬目錄並設定連線身分
foreach ($virtualPath in $virtualPaths) {
    New-IISVirtualDirectory -WebsiteName $websiteName -VirtualPath $virtualPath -PhysicalPath $physicalPath -UserName $userName -Password $password
}
