global pwb := ""
global stop := 0
global URL :="http://baseball.ticketlink.co.kr/match/view/index"
global MatchTeam := ""
global MatchDate := ""
global TicketCount := 0
global SeatRandom := True
global SeatName := ""
!F4::
{
Mousegetpos, xpos, ypos
WinGet, active_id, ID, BlueStacks App Player	;league lobby
PixelGetColor, OutputVar, xpos, ypos,rgb
msgbox %colour%, X%xpos%, Y%ypos%, %rgb%, %OutputVar%
}
return

!F1::Exit
return

!F2::stop:=!stop
!F3::
{
	Init()
	Loop
	{
	
		If stop = 1
			break
	
		Run, C:\Program Files (x86)\Internet Explorer\iexplore.exe
		sleep 500
		pwb :=	IEGet() ;ComObjCreate("InternetExplorer.Application"), pwb.Navigate(URL)
		pwb.Navigate(URL)
		IELoad(pwb)
		DebugMessage("url " URL)
		
		pwb.Visible :=	True
				
		DebugMessage("두산, LG 팀 선택")
		/*
		Loop %   (button :=   pwb.document.all.tags["a"]).length
			DebugMessage("test success[ " A_Index " ] classname: " button[A_Index-1].className " inner: " button[A_Index-1].innerText)
		*/
		
		bb = 0
		text = %MatchTeam% here
		Loop %   (button :=   pwb.document.all.tags["a"]).length
			if   (button[A_Index-1].className=MatchTeam || button[A_Index-1].className=text)
			{
				button[A_Index-1].click()
				IELoad(pwb)
				bb = 1
				Break
			}
				        
		sleep 500
        bChange = 1
        while(bChange=1)
        {    
            Loop %   (button :=   pwb.document.all.tags["a"]).length
            {
                text = %MatchTeam% here
                ;DebugMessage(button[A_Index-1].className " : " text)
                if   (button[A_Index-1].className=text)
                {
                    bChange=0
					IELoad(pwb)
                    Break
                }
            }
        }
        
		if(bb = 0)
		{
			msgbox error not found MatchTeam = %MatchTeam%
			pwb.quit
			Finish()
			return
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
				
				;DebugMessage(%MatchDate% " : " option.className " : " option.innerText " : " html )
				IfInString, html, %MatchDate%
				{
					option.click()
					bTicketOpen=1
					IELoad(pwb)
					Break
				}
			}
		
		}
				
		if(bTicketOpen=0)
		{
			DebugMessage("티켓오픈 전")
			pwb.quit
			ObjRelease(pwb)
			sleep 2000
			Continue
		}
		
		DebugMessage("티켓오픈 됨")
		
		pwb.quit
		ObjRelease(pwb)
		
		sleep 1000
		pwb := IEGet("티켓링크 티켓예매 - 스포츠 - 등급/좌석선택")
		
		if(pwb="")
		{
			DebugMessage("티켓 창 에러 ")
			msgbox 티켓 창 에러 !  MatchTeam = %MatchTeam% MatchDate = %MatchDate%
			Finish()
			return
		}
		IELoad(pwb)
		
		DebugMessage("좌석 선택")
		Loop %   (selects :=   pwb.document.all.tags["select"]).length
		{
			select := pwb.document.getElementsByName("selScale")[A_Index-1]
			options := select.getElementsByTagName("option")
			Loop % options.length
			{
				option := options[A_Index-1]
				value := option.value
								
				if(StrLen(value)<= 0)
					Continue
					
				IfInString, value, %SeatName%
				{
					DebugMessage("inner: " option.innerText " Label : " value " match : " key)				
					select.value := option.value
					select.onchange()
					
					IELoad(pwb)
					Break
				}
			}
		}
		
		DebugMessage("자동/수동 좌석 선택")
		if(SeatRandom=False)
		{
			pwb.document.getElementById("appoint").click()
			IELoad(pwb)
		}
		
		DebugMessage("다음")
		Loop %   (button :=   pwb.document.all.tags["li"]).length
			if   (button[A_Index-1].className="next_btn")
			{
				button[A_Index-1].click()
				IELoad(pwb)
			}
		
		DebugMessage("티켓 수량 ")
		selects := pwb.document.getElementById("ticketCount1")
		options := selects.getElementsByTagName("option")
		Loop % options.length
		{
			option := options[A_Index-1]
			DebugMessage("ticket : " option.innerText)
		
			if option.value+0=TicketCount
			{
				selects.value := option.value
				selects.onchange()
			
				IELoad(pwb)
				sleep 50
				Break
			}
		}

		DebugMessage("다음")
		Loop %   (button :=   pwb.document.all.tags["li"]).length
			if   (button[A_Index-1].className="next_btn_s fr")
			{
				button[A_Index-1].click()
				IELoad(pwb)
			}
		
		DebugMessage("다음")
		Loop %   (button :=   pwb.document.all.tags["li"]).length
			if   (button[A_Index-1].className="next_btn_s fr")
			{
				button[A_Index-1].click()
				IELoad(pwb)
			}
			
		DebugMessage("신용카드")
		pwb.document.getElementById("Ra002").click()
		IELoad(pwb)
		
		DebugMessage("신용카드 종류 ")
		key := "CCKM" ;KB국민
		bSetCard = False
		Loop %   (selects :=   pwb.document.all.tags["select"]).length
		{
			select := pwb.document.getElementsByName("card_cd")[A_Index-1]
			options := select.getElementsByTagName("option")
			Loop % options.length
			{
				option := options[A_Index-1]
				value := option.value
								
				if(StrLen(value)<= 0)
					Continue
					
				IfInString, value, %key%
				{
					DebugMessage("inner: " option.innerText " Label : " value " match : " key)				
					select.value := option.value
					select.onchange()
					
					IELoad(pwb)
					bSetCard = True
					Break
				}
			}
			
			if(bSetCard)
				Break
		}
		
		DebugMessage("다음")
		Loop %   (button :=   pwb.document.all.tags["li"]).length
			if   (button[A_Index-1].className="next_btn_s fr")
			{
				button[A_Index-1].click()
				IELoad(pwb)
			}
		
		msgbox 예매성공 결제해라 !  MatchTeam = %MatchTeam% MatchDate = %MatchDate%
		Break
	}
	
	Finish()
}
return

Init()
{

	DebugMessage("test start")
	
	InputBox, MatchTeam, MatchTeam, "Please enter a MatchTeam.", , 200, 100
	
	while(StrLen(MatchTeam) <= 0)
	{
		InputBox, MatchTeam, MatchTeam, "Please enter a MatchTeam.", , 200, 100
	}
	
	InputBox, MatchDate, MatchDate, "Please enter a MatchDate.", , 200, 100
	
	while(StrLen(MatchDate) <= 0)
	{
		InputBox, MatchDate, MatchDate, "Please enter a MatchDate.", , 200, 100
	}
	
	InputBox, TicketCount, TicketCount, "Please enter a TicketCount.", , 200, 100
	
	while(StrLen(TicketCount) <= 0)
	{
		InputBox, TicketCount, TicketCount, "Please enter a TicketCount.", , 200, 100
	}
	
	if(MatchTeam="dsb")
	{
		msgbox "티몬존, 메리츠화재존, 티켓링크존"
		InputBox, SeatName, 좌석 종류,  "Please enter a SeatName.", , 200, 100
		
		while(StrLen(SeatName) <= 0)
		{
			InputBox, SeatName, 좌석 종류,  "Please enter a SeatName.", , 200, 100
		}
		
		SeatName:="3루석-" SeatName
	
	}else
	{
		SeatName := "3루석-Table석"
	}
	msgbox MatchTeam = %MatchTeam% MatchDate = %MatchDate% TicketCount = %TicketCount% SeatName = %SeatName%
					
	DebugMessage("MatchDate = " MatchDate)
}

Finish()
{
	ObjRelease(pwb)	
	pwb := ""
	stop := 0
	URL :="http://baseball.ticketlink.co.kr/match/view/index"
	MatchTeam := ""
	MatchDate := ""
	TicketCount := 0
	SeatRandom := True
	SeatName := ""
	return
}

IELoad(p){
	While p.readyState!=4 || p.document.readyState!="complete" || p.busy
		Sleep 100
}

IEGet( Name:="about:blank") ; return pwb with the exact tab title
{ 
	IfEqual, Name,, WinGetTitle, Name, ahk_class IEFrame
		Name := ( Name="빈 페이지 - Windows Internet Explorer" ) ? "about:blank"
		: RegExReplace( Name, " - (Windows|Microsoft) Internet Explorer" )
	For Pwb in ComObjCreate( "Shell.Application" ).Windows
	{
		
		localName := Pwb.LocationName
		;DebugMessage("find win name : " localName " key name : " Name)
		
		if (localName=Name)
		{
			full := Pwb.FullName
			;DebugMessage("full name : " Pwb.FullName )
			IfInString, full, iexplore.exe
			{
				Return Pwb
			}
		}
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