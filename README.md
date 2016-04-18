# aporeto

Problem 1:



Problem 2:


Problem 3:
Word Count - Go Language Sample

Example runs:
run getgo.go -urls=http://www.123telugu.com/mnews/rajini-kick-starts-dubbing-for-kabali.html,http://www.123telugu.com/mnews/loafers-distributors-refute-puris-allegations.html

Parallel execution using go routines. Channels used for Synchronization

    Get list of urls from commandline
    For each URL:
		call a go routine which:
			Get text from url using HTTP Get
			Apply regex using non-AlphaNumeric characters as delimiters to get words
			Calculate a frequency table for the words
			Write the table to an output file

	For each url:
		wait for the "Over" message from the channel to ensure that the main program exits only after each url is worked upon
