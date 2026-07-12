$BaseUrl = "https://raw.githubusercontent.com/ln-komandur/elna-cam-discs/master"
$Dest = "models/original"

New-Item -ItemType Directory -Force -Path $Dest | Out-Null

$Files = @(
  @("Cam-as-18-Sided-Polygon.scad", "Cam-as-18-Sided-Polygon.scad"),
  @("Single%20Cam%20-%20No%2013.scad", "Single Cam - No 13.scad"),
  @("Single%20Cam%20-%20No%2016.scad", "Single Cam - No 16.scad"),
  @("Single%20Cam%20-%20No%2020.scad", "Single Cam - No 20.scad"),
  @("Single%20Cam%20-%20No%2033.scad", "Single Cam - No 33.scad"),
  @("Double%20Cam%20-%20No%20107.scad", "Double Cam - No 107.scad"),
  @("font.dxf", "font.dxf"),
  @("Elna%20Cam%20Dimensions.md", "Elna Cam Dimensions.md")
)

foreach ($File in $Files) {
  Invoke-WebRequest -Uri "$BaseUrl/$($File[0])" -OutFile "$Dest/$($File[1])"
}

Write-Host "Imported source models into $Dest"
