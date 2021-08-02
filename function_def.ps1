function CheckHeaders($File) {
    #$content = Get-Content -Path "/Users/gaman/Desktop/JK/june_2021/test-script.ps1"
    #Write-Host "The passed value for function is $File"
    $content = Get-Content -Path $File
    #Write-Host "the file content is : $content"
    #$all_lines = $content.Split('\n')
    #$all_lines = $content.Split('`r`n')
    $all_lines = $content.Split([Environment]::NewLine, [StringSplitOptions]::RemoveEmptyEntries)
    #Write-Host "all_lines : $all_lines"
    #Write-Host "no of header lines : " $all_lines.Count
    
    # Checking for the pre-defined keys such as "Author","Date", "Jira", "Action", "Description"
    #$keywords_to_check = 'Author', 'Script Name','Date', 'Jira', 'Action' , 'Description'
    $keywords_from_file = @()
    Import-Csv -Path "keys.csv" | foreach {
        $keywords_from_file += $_.Key
    }
    Write-Host "Headers to check : $keywords_from_file `n"
    $missing_field_present = $false
    foreach ($item  in $keywords_from_file) {
        write-host $item
        $missing_key = $true
        foreach ($line in $all_lines) {
            if ($line -match "# $item\:") {
                Write-Host "The $item header exists ...."
                $missing_key = $false
                break
            }
        }

        if ( -not $missing_key) {
            $value = $line.Split(':')[1]
            if (-not [string]::IsNullorEmpty($value)) {
                Write-Host "The value of  $item header is : $value  `n" 
            }
            else {
                Write-Host "  !!!  Warning !!!" -ForegroundColor red
                Write-Host "$item Header does not have any value `n" -ForegroundColor red
                #$missing_field_present = $true
                #break
            } 
        }
        else {
            Write-Host "$item header does not exist"
            Write-Host "!!! unable to add this file to repo !!!"
            Write-Host "please add the --$item-- header & continue"
            $missing_field_present = $true
            break
        }
    }

    write-host "Missing field present is $missing_field_present" 
    #write-host "`n All mandatory fields are present"
    return $missing_field_present
}