@REM choco管理器安装
@ https://chocolatey.org/install
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
设置安装缓存目录（非最终安装目录）
choco feature enable -n allowGlobalConfirmation
choco config set cacheLocation d:/choco_cache

@REM 常用安装包
@REM 默认安装路径 参考文档：https://docs.chocolatey.org/en-us/getting-started/#where-are-chocolatey-packages-installed-to
@REM 自定义安装路径 免费版不支持定。参考虑文档：https://docs.chocolatey.org/en-us/features/install-directory-override/
choco install -y python312 vscode