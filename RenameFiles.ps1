# Group A:
# XC105-AVU-CABCD-03-DR-M-2031
# Group B: 
# XC105-AVU-CABCD-04-DR-M-2041

# XC105-AVU-CA-03-DR-M-2031 (C02) Third Floor Ventilation & BCWS Layout Core A.pdf
# XC105-AVU-CB-03-DR-M-2032 (C02) Third Floor Ventilation & BCWS Layout Core B.pdf
# XC105-AVU-CC-03-DR-M-2033 (P01) Third Floor Ventilation & BCWS Layout Core C.pdf
# XC105-AVU-CD-03-DR-M-2034 (P01) Third Floor Ventilation & BCWS Layout Core D.pdf

# Group A:
# XC105-AVU-CABCD-03-DR-M-2031
# Group B: 
# XC105-AVU-CABCD-04-DR-M-2041

function Get-FileNames {
  param (
    $Path
  )
  process {
    Get-ChildItem -Path $Path | Where-Object { $_.extension -eq ".pdf" }
  }
}

function Split-FileNames {
  param (
    $pdfFiles
  )
  process {
    foreach ($file in $pdfFiles) {
      $regex = [Regex]::new('^(\w\w\d\d\d-\w{3}-\w)\w{4}(-[\d\w]{2}-\w+-\w+-)(\d{4} \([\d\w]{3}\) )(\d{4} \([\d\w]{3}\) )(\d{4} \([\d\w]{3}\) )(\d{4} \([\d\w]{3}\) )(.*Layout ).*(\d{4}).*(\w\w\w\w (\w))\.pdf')
      $filenameMatches = $regex.Matches($file.Name)

      $prefix = $filenameMatches.Groups[1].Value
      $floorService = $filenameMatches.Groups[2].Value
      $drawingLabel = $filenameMatches.Groups[7].Value
      $coreGroup = $filenameMatches.Groups[9].Value
      $coreLetter = $filenameMatches.Groups[10].Value

      $numberRev1 = $filenameMatches.Groups[3].Value
      $numberRev2 = $filenameMatches.Groups[4].Value
      $numberRev3 = $filenameMatches.Groups[5].Value
      $numberRev4 = $filenameMatches.Groups[6].Value
      $comaprisonGroup = $filenameMatches.Groups[8].Value
      $complexGroup = @($numberRev1, $numberRev2, $numberRev3, $numberRev4) | Where-Object { $_.StartsWith($comaprisonGroup) }

      $targetFilename = "$($prefix)$($coreLetter)$($floorService)$($complexGroup)$drawingLabel$($coreGroup).pdf"

      Write-Output $targetFilename
    }
  }
}

$Path=$args[0]

$pdfFiles = Get-FileNames($Path)
# Write-Output $pdfFiles
Split-FileNames($pdfFiles)


