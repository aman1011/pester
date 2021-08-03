BeforeAll {
    . $PSScriptRoot/function_def.ps1
}

#Describe "CheckHeaders <name>" -ForEach @(
#    @{ Name = 'a.ps1'}
#){
#    It "check-PS1_Headers" {
#        #$MISSING_FIELD_PRESENT = CheckHeaders
#        #$MISSING_FIELD_PRESENT | Should -Be $false
#        CheckHeaders -Name $name  | Should -Be $false
#    }
#}

Describe "Check For Headers" {
    It 'check-PS1_Headers' {
        Import-Csv -Path "file_to_run.csv" | foreach {
            Write-Host "File path to be processed $($_.Filename)"

            # Check if the path exists.
            $file_path = $($_.Filename)
            Write-Host "Processing file from CSV $file_path ...."
            $path_exists = Test-Path $file_path
            Write-Host "Test exists hmmmm ....."
            Write-Host $path_exists
            if ($path_exists) {
                Write-Host "Yo ...getting output ...."
                $int_val = Get-ChildItem -Path $file_path
                Write-Host $int_val
                Get-ChildItem -Path $file_path | foreach {
                    $item = $_
                    Write-Host "Item is ...."
                    Write-Host $item
                    Write-Host "The value of file is $_"
                    CheckHeaders($item)  | Should -Be $false
                }
            }
        }
    }
}


#Describe "Check for headers" {
#    Import-Csv -Path "file_to_run.csv" | foreach {
#        $file_path = $($_.Filename)
#        It "check-header" {
#            CheckHeaders($file_path)  | Should -Be $false
#        }
#    }
#}

