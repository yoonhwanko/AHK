global pwb := ""
global stop := 0
global URL :="http://baseball.ticketlink.co.kr/match/view/index"
global MatchTeam := ""
global MatchDate := ""
!F4::
{
Mousegetpos, xpos, ypos
WinGet, active_id, ID, BlueStacks App Player	;league lobby
PixelGetColor, OutputVar, xpos, ypos,rgb
msgbox %colour%, X%xpos%, Y%ypos%, %rgb%, %OutputVar%
}
return

!F2::stop:=!stop

!F3::
{
	Init()
	Loop
	{
	
		If stop = 1
			break
	
		pwb :=	ComObjCreate("InternetExplorer.Application"), pwb.Navigate(URL)
		DebugMessage("url " URL)
		
		IELoad(pwb)
		
		pwb.Visible :=	True
		
		
		;두산, LG 팀 선택
		Loop %   (button :=   pwb.document.all.tags["a"]).length
			DebugMessage("test success[ " A_Index " ] classname: " button[A_Index-1].className " inner: " button[A_Index-1].innerText)

		bb = 0
		Loop %   (button :=   pwb.document.all.tags["a"]).length
			if   (button[A_Index-1].className=MatchTeam)
			{
				button[A_Index-1].click()
				bb = 1
				Break
			}
		
		if(bb = 0)
		{
			msgbox error not found MatchTeam = %MatchTeam%
			pwb.quit
			ObjRelease(pwb)
			return
		}
		
		bChange = 1
		while(bChange=1)
		{	
			Loop %   (button :=   pwb.document.all.tags["a"]).length
			{
				text = %MatchTeam% here
				DebugMessage(button[A_Index-1].className " : " text)
				if   (button[A_Index-1].className=text)
				{
					bChange=0
					Break
				}
			}
		}
		
		bTicketOpen=0
		
		selects := pwb.document.getElementsByTagName("li")
		Loop % selects.length
		{
			select := selects[A_Index-1]
			options := select.getElementsByTagName("a")
			Loop % options.length
			{
				option := options[A_Index-1]
				html := option.outerHTML
				DebugMessage(%MatchDate% " : " option.className " : " option.innerText " : " html )
				
				IfInString, html, %MatchDate%
				{
					option.click()
					bTicketOpen=1
					Break
				}
			}
		
		}
				
		if(bTicketOpen=0)
		{
			pwb.quit
			ObjRelease(pwb)
			sleep 3000
			Continue
		}
		
	
		pwb.quit
		ObjRelease(pwb)
		
		pwb := IEGet("티켓링크 티켓예매 - 스포츠 - 등급/좌석선택")
		Loop %   (button :=   pwb.document.all.tags["a"]).length
			DebugMessage("new tab success[ " A_Index " ] classname: " button[A_Index-1].className " inner: " button[A_Index-1].innerText)
		
		
		
		;pwb.quit
		;ObjRelease(pwb)
		
		Break
	}
	
	Finish()
}
return

Init()
{

	DebugMessage("test start")
	
	InputBox, MatchTeam, "MatchTeam", "Please enter a MatchTeam.", , 200, 100
	
	while(StrLen(MatchTeam) <= 0)
	{
		InputBox, MatchTeam, "MatchTeam", "Please enter a MatchTeam.", , 200, 100
	}
	
	InputBox, MatchDate, "MatchDate", "Please enter a MatchDate.", , 200, 100
	
	while(StrLen(MatchDate) <= 0)
	{
		InputBox, MatchDate, "MatchDate", "Please enter a MatchDate.", , 200, 100
	}
	
	msgbox MatchTeam = %MatchTeam% MatchDate = %MatchDate%
	DebugMessage("MatchDate = " MatchDate)
}

Finish()
{
	pwb := ""
	stop := 0
	URL :="http://baseball.ticketlink.co.kr/match/view/index"
	MatchTeam := ""
	MatchDate := ""
	return
}

IELoad(p){
	While p.readyState!=4 || p.document.readyState!="complete" || p.busy
		Sleep 100
}

IEGet( Name="") ; return pwb with the exact tab title
{ 
	For pwb in ComObjCreate( "Shell.Application" ).Windows 
	{
	DebugMessage(Name " : " pwb.LocationName " : "  pwb.FullName)
	  If ( pwb.LocationName = Name ) && InStr( pwb.FullName, "iexplore.exe" ) 
		 Return pwb 
	}
	
	IfEqual, Name,, WinGetTitle, Name, ahk_class IEFrame ; Get active window if no parameter 
	For pwb in ComObjCreate( "Shell.Application" ).Windows 
	{
	  If ( pwb.LocationName = Name ) && InStr( pwb.FullName, "iexplore.exe" ) 
		 Return pwb 
	}
	
	Name := ( Name="New Tab - Windows Internet Explorer" ) ? "about:Tabs" : RegExReplace( Name, " - (Windows|Microsoft) Internet Explorer" )  ;
	For pwb in ComObjCreate( "Shell.Application" ).Windows 
	{
	  If ( pwb.LocationName = Name ) && InStr( pwb.FullName, "iexplore.exe" ) 
		 Return pwb 
	}
	
}

Click(x, y, color = -1, delay = 1)
{
	if(color+0==-1)
	{
		MouseClick, left, x, y
    	sleep delay*1000
	}else
	{
		if(Check(x,y,color)==1)
		{
			MouseClick, left, x, y
    		sleep delay*1000
		}
    }
}

Check(x, y, color, debug = 0) { 
	PixelGetColor, c, x, y
	if c+0==color+0
  	{	
		return 1
	}
	else
	{
		;if (debug)
			DebugMessage("Real = " c ", Input = " color ", (" x "," y ")")
	}
	return 0
}    

DebugMessage(str)
{
 global h_stdout
 DebugConsoleInitialize()  ; start console window if not yet started
 ;str .= "\n" ; add line feed
 ;DllCall("WriteFile", "uint", h_Stdout, "uint", &str, "uint", StrLen(str)+1, "uint*", BytesWritten, "uint", NULL) ; write into the console
 FileAppend  %str%`n, CONOUT$
 WinSet, Bottom,, ahk_id %h_stout%  ; keep console on bottom
 str = ""
}

DebugConsoleInitialize()
{
   global h_Stdout     ; Handle for console
   static is_open = 0  ; toogle whether opened before
   if (is_open = 1)     ; yes, so don't open again
     return
	 
   is_open := 1	
   ; two calls to open, no error check (it's debug, so you know what you are doing)
   DllCall("AttachConsole", int, -1, int)
   DllCall("AllocConsole", int)

   dllcall("SetConsoleTitle", "str","Paddy Debug Console")    ; Set the name. Example. Probably could use a_scriptname here 
   h_Stdout := DllCall("GetStdHandle", "int", -11) ; get the handle
   WinSet, Bottom,, ahk_id %h_stout%      ; make sure it's on the bottom
   WinActivate,Lightroom   ; Application specific; I need to make sure this application is running in the foreground. YMMV
   return
}

printf(string, prms*)    ; uses variadics to handle variable number of inputs
{
    padchar := " "
    
    for each, prm in prms
    {
        RegExMatch(string,"`%(.*?)([s|f])",m)
        
        format := m1
        type := m2
        
        if (type = "f") {    ; format float using setformat command
            
            originalformat := A_FormatFloat
            SetFormat, Float, %format%
            prm += 0.0
            SetFormat, Float, %originalformat%
           
        } else if (type = "s") {   ; format string (pad string if necessary, negative number indicates right justify)
        
            if (format < 0)
                loop % -format-StrLen(prm)
                    prm := padchar prm
            else
                loop % format-StrLen(prm)
                    prm := prm padchar
                    
        } else {
            msgbox, unknown type = %type% specified in call to printf
        }
        
        StringReplace, string, string, % "`" m, % prm     ; "%" symbol must be escaped with backtick
        
    }
        
    return string
}