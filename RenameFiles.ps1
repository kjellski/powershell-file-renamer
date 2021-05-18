$Path=$args[0]

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
      $sourceFilename = $file.Name
      $sourceDirectory = Split-Path -Path $file.FullName
      $sourceFilePath = "$($sourceDirectory)\$($sourceFilename)"
      
      $filenameMatches = $regex.Matches($sourceFilename)

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

      
      $targetFilePath = "$($sourceDirectory)\$($targetFilename)"
      Copy-Item -Path $sourceFilePath -Destination $targetFilePath
    }
  }
}

$pdfFiles = Get-FileNames($Path)
# Write-Output $pdfFiles
Split-FileNames($pdfFiles)


