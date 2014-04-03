# Clear screen, import functions and select tiername
clearinfo
include /home/marlub/Documents/scripts/pralign/lib.praat

form Set the variables
	comment Name for the new(or existing) tier
	sentence newtier temp

	comment Select language
	optionmenu lang: 1
		option spa
		option tze

	comment Temporary file directory
	sentence tmpdir /tmp/
	
	comment Export the graph to pdf
	boolean pdf: 0
endform
pdf$ = if pdf=1 then "True" else "False" fi
basetmp$ = "praat_temp_out"
tmp$ = tmpdir$ + basetmp$

# Get selections and set variables
tg$ = selected$("TextGrid", 1)
snd$ = selected$("LongSound", 1)

select TextGrid 'tg$'
call getTierNumber 'newtier$' tiernumber

# If the tier is present use it otherwise create it
if tiernumber = -1
	tiernumber = 1
	Insert interval tier... 1 'newtier$'
endif

# Open editor and let the user select the intervals
oldstart = -1
oldend = -1
plus LongSound 'snd$'
Edit
editor TextGrid 'tg$'
	t$ = LongSound info
	sndpath$ = extractWord$(t$, "File name: ")
endeditor
while 1=1
	# If this is not the first time, reset the screen
	if oldstart <> -1
		select TextGrid 'tg$'
		plus LongSound 'snd$'
		Edit
		editor TextGrid 'tg$'
			Zoom... 'oldstart' 'oldend'
		endeditor
	endif

	# Grab the editor and get the data from the user
	editor TextGrid 'tg$'
		pause Select a new interval to align
		start = Get start of selection
		end = Get end of selection
		label$ = Get label of interval
		Move cursor to... 'start'
		t$ = Editor info
		oldstart = extractNumber(t$, "Window start:")
		oldend = extractNumber(t$, "Window end:")
		Close
	endeditor
	
	# Clean up old boundaries and prepare for alignment
	minus LongSound 'snd$'
	call removeBetween 'tiernumber' 'start' 'end'
	Insert boundary... 'tiernumber' 'start'
	Insert boundary... 'tiernumber' 'end'
	plus LongSound 'snd$'
		
	# Print to infowindow
	printline /usr/bin/python /home/marlub/Documents/scripts/pralign/aligner.py "'label$'" 'start' 'end' 'sndpath$' 'lang$' /home/marlub/Documents/scripts/pralign/ruleset.tze False > 'tmp$'
	system  /usr/bin/python /home/marlub/Documents/scripts/pralign/aligner.py "'label$'" 'start' 'end' 'sndpath$' 'lang$' /home/marlub/Documents/scripts/pralign/ruleset.tze False > 'tmp$'

	# Read the results
	Read Table from comma-separated file... 'tmp$'

	# Put the results in the textgrid
	rows = Get number of rows
	for i to rows
		select Table 'basetmp$'
		sstart$ = Get value... 'i' start
		send$ = Get value... 'i' end
		svalue$ = Get value... 'i' label
		select TextGrid 'tg$'
		Insert boundary... 'tiernumber' 'send$'
		intnum = Get interval at time... 'tiernumber' 'sstart$'+0.0001
		Set interval text... 'tiernumber' 'intnum' 'svalue$'
	endfor

	# Remove temp files and reselect the TextGrid and LongSound
	select Table 'basetmp$'
	Remove
	select TextGrid 'tg$'
	plus LongSound 'snd$'
endwhile