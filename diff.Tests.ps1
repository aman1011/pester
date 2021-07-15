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
            $file_path = $($_.Filename)
            Write-Host "The value of file path is $file_path"
            CheckHeaders($file_path)  | Should -Be $false
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

