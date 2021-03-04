# This is a script that modifies a script created by Joyce McDonough.
# This script is designed to allow the user to create a figure from a selected portion of a spectrogram.
##########

sound1$ = selected$("Sound",1)
editor Sound 'sound1$'
Extract selected sound (time from 0)
endeditor
sound2$ = selected$("Sound",1)

			select Sound 'sound2$'
			  Erase all
			  Select outer viewport... 0 7.5 0 2.27
			  Draw... 0 0 0 0 no Curve
			  Draw inner box
			  Marks left... 2 yes yes no
			select Sound 'sound2$'
			 To Spectrogram... 0.005 5000 0.002 20 Gaussian
			 Select outer viewport... 0 7.5 1.18 6.5
			 select Spectrogram 'sound2$'
			 Paint... 0 0 0 0 100 yes 50 6 0 no
			  Draw inner box
			  Marks left... 2 yes yes no
			  Text left... no Frequency (Hz)
			  Marks bottom... 2 yes yes no
			  Text bottom... no Time (s)
		 	select Sound 'sound2$'
#			  To Pitch... 0 50 350
#			  Select outer viewport... 0 7.5 1.5 4.5
#			  Draw... 0 0 0 350 no
#			  Marks right... 3 yes yes yes
			Select outer viewport... 0 7.5 0 6.5
form Saving the figure
	comment What would you like to name the file?
	text Name Figure1
	comment Save as PNG file?
	boolean png yes
	comment Save as encapsulated Postscript file?
	boolean eps no
endform

   if 'png' = 1
     Save as 600-dpi PNG file: "'name$'.png"
   endif

   if 'eps' = 1
     Write to EPS file... 'name$'.eps
   endif


	
			select Spectrogram 'sound2$'
			Remove
			select Sound 'sound2$'
			Remove
			select Sound 'sound1$'

