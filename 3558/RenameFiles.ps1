#https://regex101.com/r/vKn8xT/1

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
      $regex = [Regex]::new('^(\w+-\w+-\w{2}-[\d\w]{2}-\w{2}-\w+-)(\d{4} \([\d\w]{3}\) )(\d{4} \([\d\w]{3}\) )(\d{4} \([\d\w]{3}\) )(\d{4} \([\d\w]{3}\) )(.*Layout )(\w+ )(\w-\w)(.*)([\d\w])\.pdf$')
      $sourceFilename = $file.Name
      $sourceDirectory = Split-Path -Path $file.FullName 
      $sourceFilePath = "$($sourceDirectory)\$($sourceFilename)"
      
      $filenameMatches = $regex.Matches($sourceFilename)

      # if it's a non matching filename
      If($filenameMatches.Groups.Count -lt 10) {
        continue
      }

      $prefix = $filenameMatches.Groups[1].Value
      $drawingLabel = $filenameMatches.Groups[6].Value
      $coreSheet = $filenameMatches.Groups[7].Value
      $tabName = $filenameMatches.Groups[9].Value
      $coreLetter = $filenameMatches.Groups[10].Value
      
      $coreLetterAdjusted = $coreLetter #to convert 5, 6, 7, 8 back into A, B, C, D
      if ($coreLetter -Like "5") {$coreLetterAdjusted = "A"}
      if ($coreLetter -Like "6") {$coreLetterAdjusted = "B"}
      if ($coreLetter -Like "7") {$coreLetterAdjusted = "C"}
      if ($coreLetter -Like "8") {$coreLetterAdjusted = "D"}
     
      #if $coreSheet = "Sheet or Sheets" write " of 4" else "" ---working!
      $suffix = ""
      if ($coreSheet -Like "*heet*") {
        $suffix = " of 4"
      }

      $numberRev1 = $filenameMatches.Groups[2].Value #can be 1,5,A
      $numberRev2 = $filenameMatches.Groups[3].Value #can be 2,6,B
      $numberRev3 = $filenameMatches.Groups[4].Value #can be 3,7,C
      $numberRev4 = $filenameMatches.Groups[5].Value #can be 4,8,D
      
      $comparisonGroup = $filenameMatches.Groups[10].Value
      #correct $comparisonGroup values to replace A with 5, B with 6 etc.
      $comparisonGroupAdjusted = $comparisonGroup
      #if ($comparisonGroup -Like "A", "B", "C", "D") {
        #$comparisonGroupAdjusted = "5", "6", "7", "8"
      #}
      if ($comparisonGroup -Like "A") {$comparisonGroupAdjusted = "5"}
      if ($comparisonGroup -Like "B") {$comparisonGroupAdjusted = "6"}
      if ($comparisonGroup -Like "C") {$comparisonGroupAdjusted = "7"}
      if ($comparisonGroup -Like "D") {$comparisonGroupAdjusted = "8"}
      
      $complexGroup = @($numberRev1, $numberRev2, $numberRev3, $numberRev4) | Where-Object { $_.Substring(3,1) -Like ($comparisonGroupAdjusted) }
      #Need to change from .StartsWith to matching the 4th character. Match either 1 or 5 / 2 or 6...

      $targetFilename = "$($prefix)$($complexGroup)$drawingLabel$($coreSheet)$($coreLetterAdjusted)$suffix.pdf"

      $targetFilePath = "$($sourceDirectory)\$($targetFilename)"
      
      Write-Output "Copy" 
      Write-Output "From: $($sourceFilePath)"
      Write-Output "To:   $($targetFilePath)"
      Write-Output "----------------------------------------------------"
      Copy-Item -Path $sourceFilePath -Destination $targetFilePath -Force
    }
  }
}

$pdfFiles = Get-FileNames($Path)
# Write-Output $pdfFiles
Split-FileNames($pdfFiles)


