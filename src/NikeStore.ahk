#include F:\Projects\AHK\src\Tools.ahk

!F4::
{
Mousegetpos, xpos, ypos
WinGet, active_id, ID, BlueStacks App Player	;league lobby
PixelGetColor, OutputVar, xpos, ypos,rgb
msgbox %colour%, X%xpos%, Y%ypos%, %rgb%, %OutputVar%
}
return

!F2::stop:=!stop

#^!F5::
{
	FormatTime, CurrentTimeString, , y/M/d
;3E3CF2E757086DEAA8267B304EDA687E
;3E3CF2E757086DEAA8267B304EDA687E
	CurrentTimeString := CurrentTimeString "geniusyoonhwan"
	MD5Hash := MD5( CurrentTimeString)
	MsgBox, %CurrentTimeString% %MD5Hash%
	DebugMessage(MD5Hash)
}
return

PassWordCheck(PWD)
{
	if(StrLen(PWD) < 5)
	{
		Return False
	}
	
	FormatTime, CurrentTimeString, , y/M/d
	CurrentTimeString := CurrentTimeString "geniusyoonhwan"
	MD5Hash := MD5( CurrentTimeString)
	IfInString, MD5Hash, %PWD%
	{
		Return True
	}
	
	Return False
}

!F3::
stop = 0

InputBox, pwd, PassWord, "Please enter password.", , 200, 100

while(PassWordCheck(pwd) == False)
{
	InputBox, pwd, PassWord, "Please enter password.", , 200, 100
}
	
DebugMessage("test start")
InputBox, ShoeName, "ShoeName", "Please enter a ShoeName.", , 200, 100

while(StrLen(ShoeName) <= 0)
{
	InputBox, ShoeName, "ShoeName", "Please enter a ShoeName.", , 200, 100
}

InputBox, ShoeSize, "ShoeSize", "Please enter a ShoeSize.", , 200, 100

while(StrLen(ShoeSize) <= 0)
{
	InputBox, ShoeSize, "ShoeSize", "Please enter a ShoeSize.", , 200, 100
}

msgbox ShoeName = %ShoeName% ShoeSize = %ShoeSize%
DebugMessage("ShoeName = " ShoeName ", ShoeSize = " ShoeSize )

URL :=	"http://twitter.com"
Run, C:\Program Files\Internet Explorer\iexplore.exe
;Run, C:\Program Files (x86)\Internet Explorer\iexplore.exe
while((pwb :=	IEGet())=="")
{} 
pwb.Navigate(URL)
IELoad(pwb)
;pwb.Visible :=	True

While(LoopTwitterSearch(pwb, ShoeName, ShoeSize) == 0)
{
	If stop = 1
		return
}

msgbox Add to Cart Success
return

LoopTwitterSearch(pwb, ShoeName, ShoeSize)
{
	IELoad(pwb)
	
	DebugMessage("StartTweetSearch" )
	twitts :=   pwb.document.getElementsByTagName("p")
	
	Loop %  twitts.length
	{
		if   (twitts[A_Index-1].className="js-tweet-text tweet-text")
		{
			twitt := twitts[A_Index-1]
			sText :=  twitt.innerText
			IfInString, sText, %ShoeName%
			{
				
				twittLink :=   twitt.getElementsByTagName("a")
				Loop %  twittLink.length
				{
					if(twittLink[A_Index-1].className = "twitter-timeline-link")
					{
						url := twittLink[A_Index-1].href
						
						DebugMessage("[" A_Index-1 "] " "URL : " url " ShoeName = " ShoeName ", ShoeSize = " ShoeSize )
						BuyNikeStoreItem(url, ShoeName,ShoeSize)
					}
				}
				
				pwb.quit
				ObjRelease(pwb)	
				Return 1
			}
		}
	}
	pwb.Refresh()
	sleep 1000
	Return 0
}

BuyNikeStoreItem(_URL, _ShoeName,_ShoeSize)
{
	;_URL :=	"http://store.nike.com/us/en_us/pd/air-zoom-pegasus-31-running-shoe/pid-1066809/pgid-1066805"

	Run, C:\Program Files\Internet Explorer\iexplore.exe
	;Run, C:\Program Files (x86)\Internet Explorer\iexplore.exe
	while((pwb :=	IEGet())=="")
	{} 
	pwb.Navigate(_URL)
	IELoad(pwb)
	
	;pwb.Visible :=	True

	;Loop %	(links :=	pwb.document.links).length
		;DebugMessage("test link " links[A_Index-1].innerText " : " A_Index)
	;[color=#FF0000]	if	(links[A_Index-1].innerText="Buy")
		;pwb.Navigate[links[A_Index-1].href,0x1000,"_self"] ;[/color]	[color=#00BF00]; 0x1000 = navOpenInBackgroundTab[/color]
	
	
	;Size
	label := ""
	selects := pwb.document.getElementsByName("skuAndSize")
	Loop % selects.length
	{
		select := selects[A_Index-1]
		options := select.getElementsByTagName("option")
		Loop % options.length
		{
			option := options[A_Index-1]
			iText := option.innerText
			IfInString, iText, %_ShoeSize%
			{
				if(option.className=="exp-pdp-size-not-in-stock")
				{

					DebugMessage("SoldOut ShoeName = " _ShoeName " ShoeSize = " _ShoeSize)
					ObjRelease(pwb)
					return
				
				}Else
				{
					label := option.value
					DebugMessage("test success[ " A_Index " ] inner: " opt.innerText " Label : " label)
					Break
				}
			}
		}
	
	}
	
	if ( StrLen(label) <= 0 )
	{
		;msgbox Err NotFound ShoeName = %_ShoeName% ShoeSize = %_ShoeSize%
		
		DebugMessage("Err NotFound ShoeName = " _ShoeName " ShoeSize = " _ShoeSize )
		ObjRelease(pwb)
		return
	}
	
	pwb.document.all.skuAndSize.value := label
		
	;Add to Cart
	Loop %   (button :=   pwb.document.all.tags["button"]).length
		if   (button[A_Index-1].className="add-to-cart nsg-button--nike-orange")
		{
			DebugMessage("test success[ " A_Index " ] classname: " button[A_Index-1].className " inner: " button[A_Index-1].innerText+0)
			button[A_Index-1].click()
		}
	
	ObjRelease(pwb)
	return
	
	Loop %   (div :=   pwb.document.all.tags["div"]).length
		if   (div[A_Index-1].className="newPrice")
		{
		  Bookdiv := pwb.document.getElementsByTagName("div")[A_Index-1]
		  divLinks := Bookdiv.getElementsByTagName("a")
		  DebugMessage("test " divLinks[0])
		;   send, {ctrl down}
		;  divLinks[0].click()
		;  send, {ctrl up}
		;  MsgBox, Click 'OK' to continue to the next book.
		}Else
		{
			;DebugMessage("test err[ " A_Index " ] classname: " div[A_Index-1].className)
		}

}
