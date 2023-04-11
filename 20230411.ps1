#載入 IIS 模組
Import-Module WebAdministration

#設定虛擬目錄屬性
$websiteName = "Default Web Site"
$virtualPath = "myapp"
$physicalPath = "C:\inetpub\wwwroot\myapp"
$userName = "myusername"
$password = "mypassword"

#建立虛擬目錄
New-Item "IIS:\Sites\$websiteName\$virtualPath" -type VirtualDirectory -physicalPath $physicalPath

#設定虛擬目錄的連線帳號密碼
Set-ItemProperty "IIS:\Sites\$websiteName\$virtualPath" -name "userName" -value $userName
Set-ItemProperty "IIS:\Sites\$websiteName\$virtualPath" -name "password" -value $password