##This is a praat script for making the images in the Speech Atlas from segmented sound files,  
## that is, .wav and TextGrids.
## June 22 2009 Joyce McDonough
## Modified bvt Apr. 2011: added a form that allows the user to interactively specify where the files are located.
#
#

form Create EPS images for publication/presentation
comment The path of the directory - choose from list:
    optionmenu Directory: 1
        option Choose from list
        option C:\Documents and Settings\bvtucker\Desktop\stimuli\
        option C:\Users\BVT-office\Desktop\FLAP_figures\figures\
comment or give the path - e.g. 'd:\sound\':
    text Directory_manual
endform

# If directory is chosen manually, select this directory
if length(directory_manual$) > 0
    directory$ = directory_manual$
endif



# Reads strings from raw text file
# Makes a Strings file called 'list' containing names of all .wav files in the specified directory

  Create Strings as file list... list 'directory$'*.wav
  n = Get number of strings
    for j from 1 to n
	     select Strings list
	     soundfile$ = Get string... 'j'

	    	Read from file... 'directory$''soundfile$'
        	object_name$ = selected$ ("Sound")
		Edit
        	Read from file... 'directory$''object_name$'.TextGrid
        	
# This is the algorithm for making the images of the spectrograms, waveform and
# textgrid with pitch contour. It saves to a .esp file in the folder.

			select Sound 'object_name$'
			  Erase all
			  Select outer viewport... 0 5 0 1.5
			  Draw... 0 0 0 0 no  Curve
			  Edit
			select Sound 'object_name$'
			 To Spectrogram... 0.005 5000 0.002 20 Gaussian
			 Select outer viewport... 0 5 0.5 3.5
			 select Spectrogram 'object_name$'
			 Paint... 0 0 0 0 100 yes 50 6 0 no
			   Draw inner box
			   Marks left... 2 yes yes no
			   Text left... no Hz
			select TextGrid 'object_name$'
			  Select outer viewport... 0 5 0 4
			  Draw... 0 0 yes yes yes
			select Sound 'object_name$'
			  To Intensity... 150 0 yes
			  Select outer viewport... 0 5 1.5 4.5
			  Draw... 0 0 0 0 no
			  Marks right... 3 yes yes yes
			Select outer viewport... 0 5 0 4.5
			Text top... no 'object_name$'
				Write to EPS file... 'directory$''object_name$'.eps
			Remove
## end of this routine
endfor
select all
Remove
print All set!










	











