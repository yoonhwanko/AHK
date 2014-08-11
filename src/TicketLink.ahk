global pwb := ""
global stop := 0
global URL :="http://baseball.ticketlink.co.kr/match/view/index"
global MatchTeam := ""
global MatchDate := ""
global TicketCount := 0
global SeatRandom := True
global SeatName := ""
global bTimer := False
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
		
		if(bTimer=False)
		{
			FormatTime, TimeString, 00000000105955, hh:mm:ss
			FormatTime, CurrentTimeString, , hh:mm:ss
			DebugMessage("time = " TimeString ", cur = " CurrentTimeString)
			if(TimeString!=CurrentTimeString)
			{
				ControlClick, x10 y10, Paddy Debug Console
				sleep 10
				Continue
			}	
			bTimer :=True
		}
		Run, C:\Program Files (x86)\Internet Explorer\iexplore.exe
		while((pwb :=	IEGet())=="")
		{} ;ComObjCreate("InternetExplorer.Application"), pwb.Navigate(URL)
		pwb.Navigate(URL)
		
		
		DebugMessage("url " URL)
		IELoad(pwb)
		
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
		
		retryCount = 10
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
			
			if(retryCount <= 0)
			{
				if(bTicketOpen=0)
				{
					DebugMessage("화면 갱신 오류 ")
					pwb.quit
					ObjRelease(pwb)
					
					sleep 2000
					Continue
				}
			}else
				retryCount := retryCount-1
        }
        
		if(bb = 0)
		{
			pwb.quit
			msgbox 팀정보 잘못 입력함. (lgt,dsb) MatchTeam = %MatchTeam%
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
		
		while((pwb :=	IEGet("티켓링크 티켓예매 - 스포츠 - 등급/좌석선택"))=="")
		{} 
		
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
					
					StringSplit, ValueArray, value, |,
					
					if(ValueArray3+0<TicketCount)
					{
						pwb.quit
						msgbox 티켓 수량 에러 !  남은 수 : %ValueArray3% 구매 수 : %TicketCount%
						Finish()
						return
					}
					
					select.value := option.value
					select.onchange()
					
					IELoad(pwb)
					Break
				}
			}
		}
		/*
		StringSplit, ValueArray, value, |,
					Loop, %ValueArray0%
					{
						subValue := ValueArray%a_index%
						DebugMessage( "index " a_index " v : " subValue ) 
					}
					*/
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
	
	InputBox, MatchTeam, 잠실 홈 팀명, 두산vs기아(dsb) LGvs기아 :(lgt), , 300, 200
	
	while(StrLen(MatchTeam) <= 0)
	{
		InputBox, MatchTeam, 잠실 홈 팀명, 두산vs기아(dsb) LGvs기아 :(lgt), , 300, 200
	}
	
	InputBox, MatchDate, 경기일, 경기일 입력 (예매오픈일 말고 경기하는 날!! ex:20140805) , , 300, 200
	
	while(StrLen(MatchDate) <= 0)
	{
		InputBox, MatchDate, 경기일, 경기일 입력 (예매오픈일 말고 경기하는 날!! ex:20140805  ) , , 300, 200
	}
	
	InputBox, TicketCount, 티켓 수량, 티켓 수량 입력 (ex:3), , 100, 200
	
	while(StrLen(TicketCount) <= 0)
	{
		InputBox, TicketCount, 티켓 수량, 티켓 수량 입력 (ex:3), , 100, 200
	}
	
	if(MatchTeam="dsb")
	{
		msgbox "티몬존, 메리츠화재존, 티켓링크존"
		InputBox, SeatName, 좌석 종류,  두산만 테이블석이 3구역으로 나누어져 있음 (ex:티몬존), , 300, 200
		
		while(StrLen(SeatName) <= 0)
		{
			InputBox, SeatName, 좌석 종류,  두산만 테이블석이 3구역으로 나누어져 있음 (ex:티몬존), , 300, 200
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