[CmdletBinding()]
param()

. $PSScriptRoot\..\..\..\Tests\lib\Initialize-Test.ps1
. $PSScriptRoot\MockVariable.ps1 -Force
. $PSScriptRoot\MockHelper.ps1 -Force

Register-Mock Get-EnvironmentResources { return $validResources } -ParametersEvaluator {$EnvironmentName -eq $validEnvironmentName}

Register-Mock Register-Environment { return GetEnvironmentWithStandardProvider $validEnvironmentName } -ParametersEvaluator{$EnvironmentName -eq $validEnvironmentName}


Register-Mock Get-EnvironmentProperty { return $validMachineName1 } -ParametersEvaluator {$Key -eq $resourceFQDNKeyName -and $ResourceId -eq $validMachineId1}
Register-Mock Get-EnvironmentProperty { return $validMachineName2 } -ParametersEvaluator {$Key -eq $resourceFQDNKeyName -and $ResourceId -eq $validMachineId2}

#Start-Job Register-Mocks
Register-Mock Start-Job { $testJobs.Add($Job1); return $job1} -ParametersEvaluator{$ArgumentList -contains $validResource1.Name }
Register-Mock Start-Job { $testJobs.Add($Job2); return $job2} -ParametersEvaluator{$ArgumentList -contains $validResource2.Name }

#Get-Job Register-Mocks
Register-Mock Get-Job { return $testJobs }

#Start-Sleep Register-Mocks
Register-Mock Start-Sleep { }

#Receive-Job Register-Mocks
Register-Mock Receive-Job { return $JobPassResponse}

#Remove-Job Register-Mocks
Register-Mock Remove-Job { $testJobs.RemoveAt(0) }

#Import-Module Register-Mocks
Register-Mock Import-Module { }

#should not throw error
& "$copyFilesToMachinesPath" -environmentName $validEnvironmentName -machineNames $validMachineNames -sourcePath $validSourcePackage -targetPath $validApplicationPath -cleanTargetBeforeCopy $true -copyFilesInParallel $true