# Group A:
# XC105-AVU-CABCD-03-DR-M-2031
# Group B: 
# XC105-AVU-CABCD-04-DR-M-2041

# XC105-AVU-CA-03-DR-M-2031 (C02) Third Floor Ventilation & BCWS Layout Core A.pdf
# XC105-AVU-CB-03-DR-M-2032 (C02) Third Floor Ventilation & BCWS Layout Core B.pdf
# XC105-AVU-CC-03-DR-M-2033 (P01) Third Floor Ventilation & BCWS Layout Core C.pdf
# XC105-AVU-CD-03-DR-M-2034 (P01) Third Floor Ventilation & BCWS Layout Core D.pdf


$files = Get-ChildItem -Name -Include *.pdf

Write-Output $files

# Group A:
# XC105-AVU-CABCD-03-DR-M-2031
# Group B: 
# XC105-AVU-CABCD-04-DR-M-2041

func
function ReadFileNames {
  param (
    Path
  )
  

}
