#dhutchen
#03/28/2019
#   This script checks for a device to be on the network. When it disconnects
#   the script minimizes currently opened windows, locks the workstation and 
#   opens Internet Explorer (I.E.) to play music or live stream. Once the 
#   device returns to the network I.E. shuts down and the windows are un-minimized. 

 
$op6t = '10.0.0.15' #Set IP of device you want to trigger script.

Function KillIE { #Closes I.E.
    
    if((Get-Process iexplore -ErrorAction SilentlyContinue) -eq $Null) {                            
                    }Else{
                        Get-Process iexplore | Stop-Process                       
                         }    
}

Function Away {
    [System.Diagnostics.Process]::Start("iexplore.exe","https://www.livenewswatch.com/cnn-news-usa.html") #Edit URL to change video/audio stream being played.
        $wshell = New-Object -ComObject wscript.shell;
        $shell = New-Object -ComObject "Shell.Application"
        $shell.minimizeall() #Minimizes currently opened windows to keep focus on I.E.
        $xCmdString = {rundll32.exe user32.dll,LockWorkStation}
        Invoke-Command $xCmdString #Locks work station
            
            do {$Ping = Test-Connection $op6t -Count 1 -Quiet #While host device is unreachable send backspace to keep screen on. 
                $Ping
                $wshell.SendKeys("{BACKSPACE}") #Sends backspace command to keep screen alive.
                Start-Sleep -S 2
                Clear-Host #Clears console 
            } Until ($Ping -eq $true)
            $shell = New-Object -ComObject "Shell.Application"
            $shell.undominimizeall() #Un-minimizes previously minimized windows.
            KillIE #Closes I.E.
            HomeAway #Loops script
}

Function HomeAway {  #Calls functions
    
    do {$Ping = Test-Connection $op6t -Count 1 -Quiet
        $Ping
        Start-Sleep -S 2
        Clear-Host
                               
    } While ($Ping -eq $true) 
        Away   
}               

HomeAway             