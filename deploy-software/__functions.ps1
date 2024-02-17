function Write-Time {
	param(
        	[string]$MSG,
		[string]$MSG_TYPE
	)
	
 	$CURRENT_TIME = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

	switch -Regex ($MSG_TYPE) {
	        "^--(ok|complete|done)|^/(ok|complete|done)" {
	        	$INDICATOR = "✓"
	        	$MSG_COL = [ConsoleColor]::Green
	        }
	        "^--(warn)|^/(warn)" {
	        	$INDICATOR = "!"
	        	$MSG_COL = [ConsoleColor]::Yellow
	        }
		"^--(err|fail)|^/(err|fail)" {
	        	$INDICATOR = "✗"
	        	$MSG_COL = [ConsoleColor]::Red
	        }
	        "^--(debug|verbose)|^/(debug|verbose)" {
	        	$INDICATOR = "."
	        	$MSG_COL = [ConsoleColor]::Magenta
	        }
	        default {
	        	$INDICATOR = " "
	        	$MSG_COL = [ConsoleColor]::White
		}
	}
	$OUTPUT_MSG= "$INDICATOR" + "[$CURRENT_TIME]`t" + "$MSG"
	Write-Host $OUTPUT_MSG -ForegroundColor $MSG_COL
}
