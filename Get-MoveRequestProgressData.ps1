[CmdletBinding()] 
param(
	[Parameter(Mandatory=$false)][switch]$HideComplete,
	[Parameter(Mandatory=$false)][switch]$HideSuspended
	)

Add-PSSnapin Microsoft.Exchange.Management.PowerShell.E2010
[System.Data.DataTable]$dt = New-Object System.Data.DataTable('MoveRequests')
$dt.Columns.Add('Username', 'string') | Out-Null
$dt.Columns.Add('Progress', 'int') | Out-Null
$dt.Columns.Add('Status', 'string') | Out-Null
$dt.Columns.Add('Bytes', 'double') | Out-Null
$dt.Columns.Add('Size', 'double') | Out-Null
$dt.Columns.Add('Detail', 'string') | Out-Null

if($HideComplete) {
	if($HideSuspended) {
		#$mr = Get-MoveRequest | ?{$_.Status -notmatch "Completed" -and $_.Status -notmatch "Suspended"}
		$mr = Get-MoveRequest -MoveStatus CompletionInProgress
		$mr += Get-MoveRequest -MoveStatus Failed
		$mr += Get-MoveRequest -MoveStatus InProgress
		$mr += Get-MoveRequest -MoveStatus Queued
	} else {
		#$mr = Get-MoveRequest | ?{$_.Status -notmatch "Completed"}
		$mr = Get-MoveRequest -MoveStatus CompletionInProgress
		$mr += Get-MoveRequest -MoveStatus Failed
		$mr += Get-MoveRequest -MoveStatus InProgress
		$mr += Get-MoveRequest -MoveStatus Queued
		$mr += Get-MoveRequest -MoveStatus Suspended
		$mr += Get-MoveRequest -MoveStatus AutoSuspended
	}
} else {
	if($HideSuspended) {
		#$mr = Get-MoveRequest | ?{$_.Status -notmatch "Suspended"}
		$mr = Get-MoveRequest -MoveStatus CompletionInProgress
		$mr += Get-MoveRequest -MoveStatus Failed
		$mr += Get-MoveRequest -MoveStatus InProgress
		$mr += Get-MoveRequest -MoveStatus Queued
		$mr += Get-MoveRequest -MoveStatus Retrying
		$mr += Get-MoveRequest -MoveStatus Completed
		$mr += Get-MoveRequest -MoveStatus CompletedWithWarning
	} else {
		$mr = Get-MoveRequest 
	}
}

ForEach($mb in $mr) {
	if($mb -ne $null) {
		$mrs = Get-MoveRequestStatistics $mb
		[System.Data.DataRow]$dr = $dt.NewRow()
		$dr['Username'] = $mb.DisplayName
		$dr['Progress'] = $mrs.PercentComplete
		$dr['Status'] = $mb.Status
		$dr['Bytes'] = $mrs.BytesTransferred.ToMB()
		$dr['Size'] = $mrs.TotalMailboxSize.ToMB()
		$dr['Detail'] = $mrs.StatusDetail
		$dt.Rows.Add($dr)
	}
}

Return , [System.Data.DataTable]$dt