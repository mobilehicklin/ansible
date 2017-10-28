. "C:\Support\DLG_Reg_Test.ps1"
import-csv C:\Support\input.csv | Test-RegistryKeys | convertTo-html |  out-file c:\support\output.html
