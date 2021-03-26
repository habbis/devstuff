<#
.SYNOPSIS
Creates VM with customized network configuration and user password. At the end script goes through sysprep.
.EXAMPLE
Deploy-VM -VMname "tst20" -IP 10.10.11.112 -NETMASK 255.255.255.0 -GW 10.10.11.250 -DNS 8.8.8.8,8.8.4.4 -sourceVM tstVM2 -resourcePool Tenants -AdminPassword Password1 -DestinationVMFolder Test -Cluster CL03 -DiskCapacityGB 120 -RAM 9 -CPUCount 3 -CDKey WC2BQ-8NRM3-FDDYY-2BFGV-KHKQY -Datastore 3PAR01-Data-01 -VMNetwork quarantine
In this example you are going to create VM with from vm tstVM2 as a source. CDKey is KMS or any acceptable key for Windows OS you are trying to install.
#>
 
    param(
        [Parameter(Mandatory=$true, Position=0)]      
        [string]$VMname,
        [Parameter(Mandatory=$true, Position=1)]      
        [ipaddress]$IP,
        [Parameter(Mandatory=$true, Position=2)]      
        [ipaddress]$GW,
        [Parameter(Mandatory=$true, Position=3)]      
        [string]$NETMASK,
        [Parameter(Mandatory=$true, Position=4)]      
        [array]$DNS,
        [Parameter(Mandatory=$true, Position=5)]      
        [string]$sourceVM,
        [Parameter(Mandatory=$true, Position=6)]
        [string]$resourcePool,
        [Parameter(Mandatory=$true, Position=7)]
        [string]$AdminPassword,
        [Parameter(Mandatory=$true, Position=8)]
        [string]$DestinationVMFolder,
        [Parameter(Mandatory=$true, Position=9)]
        [string]$Cluster,
        [Parameter(Mandatory=$true, Position=10)]
        [decimal]$DiskCapacityGB,
        [Parameter(Mandatory=$true, Position=11)]
        [string]$RAM,
        [Parameter(Mandatory=$true, Position=12)]
        [string]$CPUCount,
        [Parameter(Mandatory=$true, Position=13)]
        [string]$CDKey,
        [Parameter(Mandatory=$true, Position=14)]
        [string]$Datastore,
        [Parameter(Mandatory=$true, Position=15)]
        [string]$PortGroupName
 
      
    )
 
    $sourceVMasVM = $null
    $nicMap = $null
 
    if(!(Get-Datastore $Datastore 2> $null)){
        Write-Host -ForegroundColor Yellow "$Datastore datastore cannot be found in connected vCenter.`nExiting..."
        return
    }
 
    if((Get-VM -Name $VMname 2> $null)){
        Write-Host -ForegroundColor Yellow "VM $VMname already exsist.`nExiting..."
        return
        }
        
    if(!(Get-Folder $DestinationVMFolder 2> $null)){
       Write-Host -ForegroundColor Yellow  "Folder $DestinationVMFolder not found. We are going to create into Tenant..."
       Try{
       New-Folder -Name $DestinationVMFolder -Location "Tenants" -ErrorAction Stop | Out-Null
       Write-Host -ForegroundColor Green "$DestinationVMFolder folder succesfully created..."
       } catch {
                Write-Host -ForegroundColor Red "Unable to create $DestinationVMFolder, ERROR: $_"
                return
                }
    }else{
        Write-Host -ForegroundColor Green "$DestinationVMFolder folder selected as destination for $VMname VM..."
    }
 
    Write-Host -ForegroundColor Green "$Datastore datastore has been randomly selected from 3 least loaded..."
 
 
    if(!($VMHost = Get-Cluster $Cluster | Get-VMHost | Where-Object{$_.ConnectionState -eq "Connected"}| Get-Random)){
        Write-Host -ForegroundColor Red "Unable to choose VMHost in $Cluster"
        return
    }
    Write-Host -ForegroundColor Green "Following ESXi has been randomly selected: $VMHost as host in $Cluster cluster.."
 
    try{
        $sourceVMasVM = Get-VM -Name $sourceVM -ErrorAction Stop
        } catch {Write-Host -ForegroundColor Red "Unable to find source VM $sourceVM, ERROR: $_"
                return
                }
 
    if(($sourceVMasVM.ProvisionedSpaceGB -gt $DiskCapacityGB)){
       Write-Host -ForegroundColor Red "Disk for new VM shold be great or equal template vm size.`nSource VM disk size: "$sourceVMasVM.ProvisionedSpaceGB". Requested size is: $DiskCapacityGB" -Separator ""
       return
    }
 
    try{
            $resourcePool = Get-ResourcePool $resourcePool -ErrorAction Stop
        } catch {
                    Write-Host -ForegroundColor Red "Resource pool $resourcePool not found in $Cluster"
                    return 
                }
    
    try{
            Write-Host -ForegroundColor Green "#################################`n#`tStarting VM Provisioning`t#`n#`################################"
            New-VM -Name $VMname -VM $sourceVM -ResourcePool $resourcePool -VMHost $VMHost -Datastore $Datastore -ErrorAction Stop | Out-Null
            Write-Host -ForegroundColor Green "VM $VMname has been created..."
        } catch {Write-Host -ForegroundColor Red "Unable to create $VMname ERROR: $_"
                return
                }
    
 
    try{
        $nicMap = Get-OSCustomizationNicMapping -OSCustomizationSpec (New-OSCustomizationSpec -OSType Windows -Type NonPersistent -ProductKey $CDKey -FullName Wincd12-Sj -OrgName OrgSXn1-112 -Workgroup "WORKGROUP" -ChangeSid -AdminPassword $AdminPassword -ErrorAction Stop)
        $nicMap | Set-OSCustomizationNicMapping -IpMode UseStaticIP $IP -SubnetMask $NETMASK -DefaultGateway $GW -Dns $DNS -ErrorAction Stop | Out-Null
        Set-VM $VMName -OSCustomizationSpec $nicMap.Spec -NumCpu $CPUCount -MemoryGB $RAM -Confirm:$false | Out-Null
        Remove-OSCustomizationSpec $nicMap.Spec.Name -Confirm:$false
    } catch {
        Write-Host -ForegroundColor Red "Unable to create IP customization ERROR: $_"
        Write-Host -ForegroundColor Yellow "You should either change VM setting manually or remove VM $VMname"
        $userInput = ''
        while($userInput.ToLower() -notmatch "(yes|no)"){
            $userInput = Read-Host "Would you like to remove $VMname Yes/No"
        }
        if(($userInput -eq "yes")){
                                    Remove-VM -VM $VMname -DeletePermanently -Confirm:$false
                                    Write-Host -ForegroundColor Green "$VMname has been removed"
                                    }
        
        return
    }
 
    try{Write-Host -ForegroundColor Green "Connecting $VMname VM to $PortGroupName port group..."
        $PortGroup = Get-VirtualPortGroup -Name $PortGroupName -ErrorAction Stop
        $NetworkAdapter = Get-NetworkAdapter $VMname -ErrorAction Stop
        Set-NetworkAdapter -NetworkAdapter $NetworkAdapter -Portgroup $PortGroup -Confirm:$false -ErrorAction Stop | Out-Null
        Set-NetworkAdapter -NetworkAdapter $NetworkAdapter -StartConnected:$true -Confirm:$false -ErrorAction Stop| Out-Null
        } catch {
                Write-Host -ForegroundColor Yellow "Unable to join network ERROR: $_"
                Write-Host -ForegroundColor Yellow "You should either change VM setting manually or remove VM $VMname"
                $userInput = ''
                while($userInput.ToLower() -notmatch "(yes|no)"){
                    $userInput = Read-Host "Would you like to remove $VMname Yes/No"
                    }
                    if(($userInput -eq "yes")){
                        Remove-VM -VM $VMname -DeletePermanently -Confirm:$false
                        Write-Host -ForegroundColor Green "$VMname has been removed"
                    }
        
        return 
        
        }
 
 
    try{
        Write-Host -ForegroundColor Green "Setting HardDisk Size to $DiskCapacityGB..."
        Get-HardDisk -VM (Get-VM -Name $VMname) | Set-HardDisk -CapacityGB $DiskCapacityGB -Confirm:$false | Out-Null
        Write-Host -ForegroundColor Green "Setting IP to $IP... Netmask: $NETMASK Gateway: $GW..."
    } catch {
                Write-Host -ForegroundColor Red "Unable to set diskSize. ERROR: $_"
                Write-Host -ForegroundColor Red "You should either change VM setting manually or remove VM $VMname"
                return
            }
    
    try{
        Write-Host -ForegroundColor Green "Moving VM to $DestinationVMFolder..."
        Move-VM $VMname -Destination $DestinationVMFolder -Confirm:$false -ErrorAction Stop | Out-Null
        Write-Host -ForegroundColor Green "Starting $VMname..."
        Start-VM $VMname -Confirm:$false | Out-Null
        } catch {
                Write-Host -ForegroundColor Red "Cannot Move or Start $VMname. ERROR: $_"
                return
                }
 
    Write-Host -ForegroundColor Cyan "Virtual machine short information"
    Write-Host -ForegroundColor Cyan "---------------------------------"
    Write-Host -ForegroundColor Cyan "VM name:`t$VMname"
    Write-Host -ForegroundColor Cyan "Username:`tAdministrator"
    Write-Host -ForegroundColor Cyan "Password:`t$AdminPassword"
    Write-Host -ForegroundColor Cyan "IP:`t`t$IP"
    Write-Host -ForegroundColor Cyan "CPU core count:`t$CPUCount"
    Write-Host -ForegroundColor Cyan "RAM:`t$RAM GB"
    Write-Host -ForegroundColor Cyan "Location:`t$DestinationVMFolder"
}