#--------------------------------------------
# Declare Global Variables and Functions here
#--------------------------------------------

Function ResizeImage()
{
	param ([String]$ImagePath,
		[Int]$Quality = 90,
		[Int]$NewSize,
		[String]$Export)
	
	Add-Type -AssemblyName "System.Drawing"
	
	$img = [System.Drawing.Image]::FromFile($ImagePath)
	
	$CanvasWidth = $NewSize
	$CanvasHeight = $NewSize
	
	#Encoder parameter for image quality
	$ImageEncoder = [System.Drawing.Imaging.Encoder]::Quality
	$encoderParams = New-Object System.Drawing.Imaging.EncoderParameters(1)
	$encoderParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter($ImageEncoder, $Quality)
	
	# get codec
	$Codec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where { $_.MimeType -eq 'image/jpeg' }
	
	#compute the final ratio to use
	$ratioX = $CanvasWidth / $img.Width;
	$ratioY = $CanvasHeight / $img.Height;
	
	$ratio = $ratioY
	if ($ratioX -le $ratioY)
	{
		$ratio = $ratioX
	}
	
	$newWidth = [int] ($img.Width * $ratio)
	$newHeight = [int] ($img.Height * $ratio)
	
	$bmpResized = New-Object System.Drawing.Bitmap($newWidth, $newHeight)
	$graph = [System.Drawing.Graphics]::FromImage($bmpResized)
	$graph.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
	
	$graph.Clear([System.Drawing.Color]::White)
	$graph.DrawImage($img, 0, 0, $newWidth, $newHeight)
	
	#save to file
	$bmpResized.Save($Export, $Codec, $($encoderParams))
	$bmpResized.Dispose()
	$img.Dispose()
}





#Sample function that provides the location of the script
function Get-ScriptDirectory
{
<#
	.SYNOPSIS
		Get-ScriptDirectory returns the proper location of the script.

	.OUTPUTS
		System.String
	
	.NOTES
		Returns the correct path within a packaged executable.
#>
	[OutputType([string])]
	param ()
	if ($null -ne $hostinvocation)
	{
		Split-Path $hostinvocation.MyCommand.path
	}
	else
	{
		Split-Path $script:MyInvocation.MyCommand.Path
	}
}

#Sample variable that provides the location of the script
[string]$ScriptDirectory = Get-ScriptDirectory


