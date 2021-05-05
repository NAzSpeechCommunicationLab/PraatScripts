# A TextGrid object needs to be selected in the Object list.
#
#
# This script is distributed under the GNU General Public License.
# Copyright 12.3.2002 Mietta Lennes
#
# Changes and additions by bvt 2006, 2011

# A TextGrid and sound file must be selected in the object list to procede.
sound$ = selected$("Sound",1)
grid$ = selected$("TextGrid",1)

select TextGrid 'grid$'
# ask the user for the tier number

form Calculate durations of labeled segments
	comment Which tier of the TextGrid object would you like to analyse?
	integer Tier 1
	comment What is the name of your output file?
	text Output output.txt
endform

# check how many intervals there are in the selected tier:
	numberOfIntervals = Get number of intervals... tier

#a = 0
# loop through all the intervals
for interval from 1 to numberOfIntervals
	label$ = Get label of interval... tier interval
# if the interval has some text as a label, then calculate the duration.
	if label$ <> ""
		start = Get starting point... tier interval
		end = Get end point... tier interval
		duration = end - start
#		a = a + 1
		
# Create the sound file and save it, the script will save the WAV file in the directory that the script is in.
    select Sound 'sound$'
    Extract part... 'start' 'end' Rectangular 1 no
    Rename... 'label$'
#   Write to WAV file... 'label$'_'a'.wav
    Write to WAV file... 'label$'.wav
    Remove
    
    select TextGrid 'grid$'
    
# append the label and the duration to the end of the text file, separated with a tab:
#		resultline$ = "'label$'_'a'	'duration''newline$'"
		resultline$ = "'label$'	'duration''newline$'"
		fileappend "'output$'" 'resultline$'
	endif
endfor

echo Finished!
