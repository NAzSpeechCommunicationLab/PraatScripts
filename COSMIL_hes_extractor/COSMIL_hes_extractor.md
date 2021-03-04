# COSMIL_hes_extractor.praat

Search the COSMIL data for a list of items and extracts acoustic information on those items.

Created by bvt Sep. 2020

## Procedures

### speechRate: *.start*, *.end*, *.segTier*, *.wordTier*

Calculate the 3sec speech rate based on number of vowels in the window. Also outputs average speaker rate over the whole file. Procedure assumes stress is marked using ARPABET. Requires start = starting boundary of the segment of interest, end = ending boundary of the segment of interest, segTier = the segment level tier, wordTier = word level tier.

### pitchProc: *.start*, *.end*, *.f0min*, *.f0max*, *.first*, *.mid*, *.lquart*



### intensityProc: *.f0min*, *.first*, *.mid*, *.lquart*



### formantProc: *.nform*, *.maxfreq*, *.mid*, *.first*, *.third*, *.lquart*


