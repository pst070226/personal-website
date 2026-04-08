Add-Type -AssemblyName System.Drawing

$quality = 70
$encoder = [System.Drawing.Imaging.Encoder]::Quality
$encoderParams = New-Object System.Drawing.Imaging.EncoderParameters(1)
$encoderParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter($encoder, $quality)
$jpegEncoder = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq 'image/jpeg' }

$imageFolders = @("images\drawing", "images\pets", "images\modeling")

foreach ($folder in $imageFolders) {
    $fullPath = Join-Path $PSScriptRoot $folder
    if (Test-Path $fullPath) {
        Get-ChildItem $fullPath -Filter *.jpg | ForEach-Object {
            $file = $_
            $originalSize = $file.Length / 1MB
            Write-Host "Processing: $($file.Name) ($([math]::Round($originalSize, 2)) MB)"
            
            try {
                $img = [System.Drawing.Image]::FromFile($file.FullName)
                $newPath = $file.FullName + ".tmp"
                $img.Save($newPath, $jpegEncoder, $encoderParams)
                $img.Dispose()
                
                Remove-Item $file.FullName -Force
                Rename-Item $newPath $file.Name
                
                $newSize = (Get-Item $file.FullName).Length / 1MB
                Write-Host "  Compressed: $([math]::Round($newSize, 2)) MB (saved $([math]::Round(($originalSize - $newSize) / $originalSize * 100, 1))%)"
            }
            catch {
                Write-Host "  Error: $_"
            }
        }
    }
}

Write-Host "`nDone!"