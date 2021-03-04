###################
# 
#' Search the COSMIL data for a list of items and extracts acoustic information on those items.
#'
#' Created by bvt Sep. 2020
#
#############


form Give the parameters for the search and extract
   comment This script extracts words from the Buckeye Corpus given a file with a list of words needed for extraction.
   comment The path of the directory - choose from list:
    optionmenu Directory: 1
        option Choose from list
      	option G:\location\COSMIL_RecordingsAndAlignments\test
      	option /Users/location/COSMIL_hes_dataset
#   comment The path for the wordlist file:
#    text Wordlist D:\Buckeye_Corpus\irreglist.txt
   comment Specify the slash direction "\" for Windows and "/" for everything else.
    	text Slash \
   comment What do you want to name the output file?
	text Name output.txt
   comment Number of formants?
	positive nform 5
   comment Maximum frequency range?
	positive maxfreq 5500
   comment Pitch Range?
	positive f0min 75
	positive f0max 500
endform

# Here we create a list of items that we want to search for and do some extraction.
# wordList$ = Create Strings as tokens: "AX1M AH1M EH1M AX1 AH1 AE1 AA1 ER1", " ,"
wordList$ = Create Strings as tokens: "UH UM ER", " ,"

#Add the header to the file.
fileappend "'name$'" FileName	wordm2	wordm1	word	wordp1	wordp2	Like_Num	start	word_dur	wordm1_dur	wordp1_dur	seg_dur	pitch_mean	pitch_25	pitch_m	pitch_75	intMean	intMax	intMin	int_m	int_25	int_75	vmf1	vmf2	vmf3	v25f1	v25f2	v25f3	v33f1	v33f2	v33f3	v75f1	v75f2	v75f3	SegRate	SyllRate	SpeakerSyllRate	SpeakerRate'newline$'

list$ = selected$("Strings",1)
numWords = Get number of strings

Create Strings as file list... list 'directory$''slash$'*.wav
  Change... .wav "" 0 Literals
  Rename...  list5
  select Strings list
  Remove
  select Strings list5
	numberOfFiles = Get number of strings
	for ifile to numberOfFiles
	    soundname$ = Get string... ifile
		if soundname$ <> ""
			Read from file... 'directory$''slash$''soundname$'.wav
			sound$ = selected$("Sound",1)
			Read from file... 'directory$''slash$''soundname$'.TextGrid
			grid$ = selected$("TextGrid",1)
			numInt = Get number of intervals... 2
			likeNum = Count intervals where: 2, "contains", "LIKE"
#Now we loop through the intervals
			for int to numInt
				select TextGrid 'grid$'
				label$ = Get label of interval... 2 int
				# This verifies that the string is in our list
				for word to numWords
					select Strings 'list$'
					string$ = Get string... word
					select TextGrid 'grid$'

					if label$ = "'string$'"
						labelm1$ = Get label of interval... 2 int-1
						labelm2$ = Get label of interval... 2 int-2
						labelp1$ = Get label of interval... 2 int+1
						labelp2$ = Get label of interval... 2 int+2
						#Count the number of likes in the conversation for comparison
						
						start = Get starting point... 2 'int'
						end = Get end point... 2 'int'
						dur = end - start
						word_dur = dur
						startP = start-0.03
						endP = end+0.03
						mid = (dur*0.5)+start
						first = (dur*0.25)+start
						third = (dur*0.33)+start
						lquart = (dur*0.75)+start

					#Get duration of preceding and following intervals
						startm1 = Get starting point... 2 'int'-1
						endm1 = Get end point... 2 'int'-1
						wordm1_dur = endm1 - startm1
						startp1 = Get starting point... 2 'int'+1
						endp1 = Get end point... 2 'int'+1
						wordp1_dur = endp1 - startp1

						#Get SPEECH RATE
						segInterval = 1
						wordInterval = 2
						select TextGrid 'grid$'
						@speechRate: start, end, segInterval, wordInterval

						select Sound 'sound$'
						Extract part... startP endP Rectangular 1 yes
						#Get PITCH
						@pitchProc: start, end, f0min, f0max, first, mid, lquart

						#Get INTENSITY
						select Sound 'sound$'_part
						@intensityProc: f0min, first, mid, lquart

						#Get the FORMANT values
						if label$ = "UM"
						#MEASURE FORMANTS FOR JUST AH1
						  select TextGrid 'grid$'
						  tgPart = Extract part... start end yes
						  numI = Get number of intervals... 1
						  for i to numI
						    label1$ = Get label of interval... 1 i
						    if label1$ = "AH1"
						      start = Get starting point... 1 'i'
						      end = Get end point... 1 'i'
						      dur = end - start
						      mid = start+(dur*0.5)
						      first = start+(dur*0.25)
						      third = start+(dur*0.33)
						      lquart = start+(dur*0.75)
						      select Sound 'sound$'_part
						      @formantProc: nform, maxfreq, mid, first, third, lquart
						      selectObject: tgPart
						    endif
						  endfor
						removeObject: tgPart
						else
						  select Sound 'sound$'_part
						  @formantProc: nform, maxfreq, mid, first, third, lquart
						endif
						select Sound 'sound$'_part
						Remove
		#Print the results of out code
		resultline$ = "'soundname$'	'labelm2$'	'labelm1$'	'label$'	'labelp1$'	'labelp2$'	'likeNum'	'start'	'word_dur'	'wordm1_dur'	'wordp1_dur'	'dur'	'pitchMean'	'pitch_25'	'pitch_m'	'pitch_75'	'intMean'	'intMax'	'intMin'	'int_m'	'int_25'	'int_75'	'vmf1'	'vmf2'	'vmf3'	'v25f1'	'v25f2'	'v25f3'	'v33f1'	'v33f2'	'v33f3'	'v75f1'	'v75f2'	'v75f3'	'segRate6'	'syllRate6'	'speakerSyllRate'	'speakerSegRate''newline$'"
		fileappend "'name$'" 'resultline$'

					endif
				endfor
			endfor
		endif
		select Strings list5
	endfor

	select Strings list5
	Remove

echo C'est finis!

#' Calculate the 3sec speech rate based on number of vowels in the window. Also outputs average speaker rate over the whole file. Procedure assumes stress is marked using ARPABET.
#' Requires start = starting boundary of the segment of interest, end = ending boundary of the segment of interest, segTier = the segment level tier, wordTier = word level tier.
procedure speechRate: .start .end .segTier .wordTier
	start3 = start-3
	end3 = end+3
	dur6 = end3-start3
	intStart3 = Get interval at time: wordTier, start3
	intEnd3 = Get interval at time: wordTier, end3
	numInt1 = intEnd3-intStart3
	segRate6 = numInt1/dur6
	srTG = Extract part: 'start3', 'end3', "no"
	  vowel0 = Count intervals where: 1, "ends with", "0"
	  vowel1 = Count intervals where: 1, "ends with", "1"
	  vowel2 = Count intervals where: 1, "ends with", "2"
	  vowelNum = vowel0+vowel1+vowel2
	removeObject: srTG
	syllRate6 = vowelNum/dur6
	select TextGrid 'grid$'
	#Speaker Rate
	numInt11 = Get number of intervals... segTier
	  vowelA0 = Count intervals where: 1, "ends with", "0"
	  vowelA1 = Count intervals where: 1, "ends with", "1"
	  vowelA2 = Count intervals where: 1, "ends with", "2"
	  vowelANum = vowelA0+vowelA1+vowelA2
	#Could just do this as a count of vowels
	totDur = Get total duration
	speakerSyllRate = vowelANum/totDur
	speakerSegRate = numInt11/totDur
endproc

procedure pitchProc: .start .end .f0min .f0max .first .mid .lquart
	To Pitch... 0 f0min f0max
	pitchMean = Get mean: start, end, "Hertz"
	pitch_m = Get value at time... 'mid' Hertz Linear
	pitch_25 = Get value at time... 'first' Hertz Linear
	pitch_75 = Get value at time... 'lquart' Hertz Linear
	Remove
endproc

procedure intensityProc: .f0min .first .mid .lquart
	To Intensity: f0min, 0, "yes"
	intMean = Get mean: 0, 0, "energy"
	intMin = Get minimum: 0, 0, "Parabolic"
	intMax = Get maximum: 0, 0, "Parabolic"
	int_m = Get value at time: 'mid', "Cubic"
	int_25 = Get value at time: 'first', "Cubic"
	int_75 = Get value at time: 'lquart', "Cubic"
	Remove
endproc

procedure formantProc: .nform .maxfreq .mid .first .third .lquart
	To Formant (burg)... 0.001 nform maxfreq 0.025 50
	midF = Get frame number from time... 'mid'
	firstF = Get frame number from time... 'first'
	thirdF = Get frame number from time... 'third'
	lquartF = Get frame number from time... 'lquart'
	midFr = round(midF)
	firstFr = round(firstF)
	thirdFr = round(thirdF)
	lquartFr = round(lquartF)
	lquartT = Get time from frame number... 'lquartFr'
	midT = Get time from frame number... 'midFr'
	firstT = Get time from frame number... 'firstFr'
	thirdT = Get time from frame number... 'thirdFr'
	vmf1 = Get value at time... 1 'midT' Hertz Linear
	vmf2 = Get value at time... 2 'midT' Hertz Linear
	vmf3 = Get value at time... 3 'midT' Hertz Linear
	v25f1 = Get value at time... 1 'firstT' Hertz Linear
	v25f2 = Get value at time... 2 'firstT' Hertz Linear
	v25f3 = Get value at time... 3 'firstT' Hertz Linear
	v33f1 = Get value at time... 1 'thirdT' Hertz Linear
	v33f2 = Get value at time... 2 'thirdT' Hertz Linear
	v33f3 = Get value at time... 3 'thirdT' Hertz Linear
	v75f1 = Get value at time... 1 'lquartT' Hertz Linear
	v75f2 = Get value at time... 2 'lquartT' Hertz Linear
	v75f3 = Get value at time... 3 'lquartT' Hertz Linear
	Remove
endproc
