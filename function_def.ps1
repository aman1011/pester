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
        $missing_key = $true
        Write-Host "Checking header $item" -ForegroundColor Blue
        if ($item -match ';') {
            # placeholder.
            # check for the first element.
            # if first element is not present straight to hell.
            Write-Host "Entering into ; ...."
            $first_element_present = if_first_element_present $all_lines $item
            Write-Host "First element present $first_element_present"
            if ($first_element_present) {
                $missing_key = check_multi_items $all_lines $item
                Write-Host "Missing key in $missing_key before reversing ...."
                if ($item -match '\$update' -or $item -match '\$delete') {
                    Write-Host "Reversed yo ...."
                    $missing_key = !$missing_key
                } 
                Write-Host "Missing key in $missing_key ...."
                if ($missing_key) {
                    Write-Host "Consecutive strings have issues ...." -ForegroundColor White
                    $missing_field_present = $true
                    break
                }
            }
            else {
                Write-Host "First element was not present. Woolooloo . This is a failure"
                $missing_field_present = $true
                break
            } 
        }
        else {
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
                     if (-not $value -match '^\S+$') {

                         # This means the value is not set.
                         # The value is only some white space character/
                        Write-Host "  !!!  Warning !!!" -ForegroundColor red
                        Write-Host "$item Header does not have any value `n" -ForegroundColor red
                     }
                     else {
                        Write-Host "The value of  $item header is : $value  `n" 
                     }
                } elseif ( $value -match $value) {
                    Write-Host "Only space hmmmm."
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
    }

    write-host "Missing field present is $missing_field_present" 
    #write-host "`n All mandatory fields are present"
    return $missing_field_present
}


function if_first_element_present($lines, $item) {
    $first_element_present = $false
    $first_element = $item.Split(';')[0]
    Write-Host "First element $first_element"
    foreach ($line in $lines) {
        if ($line -match $first_element) {
            Write-Host "Reaching here ...." -ForegroundColor Blue
             $first_element_present = $true
        }
    }
    return $first_element_present
}

function check_multi_items($lines, $item) {

    $all_items = $item.Split(';')
    $first_elem = $all_items[0]
    for ($i = 1; $i -lt $all_items.length; $i++) {
        $second_elem = $false
        $to_check = $all_items[$i]
        Write-Host $all_items[$i]

        foreach ($line in $lines) {
            if ($line -match $to_check -and $line -match $first_elem) {
                $second_elem = $true
                break
            }
        }
        Write-Host "The second elem is $second_elem ...." -ForegroundColor Yellow
    }

    Write-Host "Value of first element is $first_element_present"
    Write-Host "Value of second element is $second_elem"
    if ($first_element_present -and -not $second_elem) {
        Write-Host "yoloing in the first if ...."
        return $true
    }
    else {
        Write-Host "tinkering for false ...."
        return $false
    }
}