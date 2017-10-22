function Test-RegistryKeyValue
{
    <#
    .SYNOPSIS
    Tests if a registry value exist, can test keys and the vaules of a key.

    the function is built using the $val = (Get-ItemProperty -path $Path).$Name design

    .DESCRIPTION
    This function when run can be called at command line or via an imput table. it is desiged to locate registry setting and values for compliance testing.

    .EXAMPLE
    Test-RegistrykeyValue -Path 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\' -Name 'ForceUnlockLogon' -Value '1'
    
    the function can run using inputs from a csv file

    import-csv <filename.csv> | Test-RegistryValue

    the CSV must be formated as:

    TESTNAME,PATH,KEY,VALUE
    test1,HKLM:\SOFTWARE\7-zip,test,newtest

    #>
    [CmdletBinding()]
Param	(
         [parameter(Position=0,Mandatory=$True,ValueFromPipelineByPropertyName=$true)]$TESTNAME,
         [parameter(Position=1,Mandatory=$true,ValueFromPipelineByPropertyName=$true)][string]$PATH,
         [parameter(Position=2,Mandatory=$false,ValueFromPipelineByPropertyName=$true)][string]$KEY,
         [parameter(Position=3,Mandatory=$false,ValueFromPipelineByPropertyName=$true)][string]$VALUE
        )
         

Process
	{
		Write-Verbose "--Start of Process Block--"

		Write-Verbose "Checking Pipeline inputs and parameteres"
		If($_)		{
			        Write-Verbose "Pipeline input detected and targetscope parameter"
                    $NAME = $_.TESTNAME
                    $PATH = $_.PATH
                    $KEY = $_.KEY 
                    $VALUE = $_.VALUE
                    
                    IF($_.TESTNAME)
                    {$TESTNAME = $_.TESTNAME}
                    IF($_.PATH)
                    {$PATH = $_.PATH}
                    IF($_.KEY)
                    {$KEY = $_.KEY}
                    IF($_.VALUE)
                    {$VALUE = $_.VALUE}		
		            }

write-verbose "TESTNAME = $TESTNAME"
Write-verbose "PATH = $PATH"
write-verbose "KEY = $KEY"
Write-verbose "VALUE = $VALUE"

FOREACH ($_ IN $TESTNAME)
        {$TestPATH = (test-path $PATH)
        if ($TestPATH -eq "True")
            {write-host "TESTNAME:-$TESTNAME STATUS Located $PATH"
            $TESTNAMERESULT = "PASSED"
            if ($KEY -gt '')
            {
                if (Get-ItemProperty -Path $PATH -name $KEY -ErrorAction SilentlyContinue)
                    {Write-Host "T$TESTNAME Found key $KEY"
                    $TESTNAMERESULT = "PASSED"
                        if ($VALUE -gt '')
                            {$TestValue = Get-ItemPropertyValue -path $PATH -Name $KEY -ErrorAction SilentlyContinue
                            write-host "$TESTNAME information Found the value $TestVALUE testing if it is the same as the required value! of $VALUE"
                                if ($TestValue -eq $VALUE)
                                    {$REASON =  "Value $testvalue matched to required seting of $VALUE"
                                    $TESTNAMERESULT = "PASSED"
                                    }
                                    Else
                                    {$REASON = "the Value $VALUE is not a match the current value of the key is: $testvalue"
                                    $TESTNAMERESULT = "FAILED"
                                    }
                            }
                                Else
                            {$REASON =  "INformation No Registry Value defined in the test!"
                            }  
                    }
                Else        
                {$REASON = "FAILED Failed to locate the Registry key $KEY using the Value of $PATH"
                $TESTNAMERESULT = "FAILED"
                }
                }
                }
                Else
            {$REASON = "FAILED Failed to locate $PATH"
            $TESTNAMERESULT = "FAILED"
            }

        "$TESTNAME RESULT $TESTNAMERESULT"
        # This will close the code section
        }
    "$TESTNAME RESULT $TESTNAMERESULT with $REASON"| fl | Out-File C:\Suport\result.txt -Append
    }
# This will close the function
}
