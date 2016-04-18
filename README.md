# aporeto

Problem 1:
sample runs:
./states.sh --create-file="a" --verbose
./states.sh --create-file="abc.txt"


Parse the command kind options and arguments
Create a file or overwrite existing file with 50 states based on options provided.



Problem 2:
Uniquify

sample run:
python unique.py --file=big_file.txt --output="ooo.txt

Algorithm:
	Declare a hashSet which stores md5 and length of a line
	
	for each line in the file:
		compute (md5, len) of the line
		if (md5, len) is already present in hashSet, ignore the line
		else add the (md5, len) to hashSet() and write this line to output file

Notes:
If a collision occurs in MD5 there is a possibility of ignoring a line which is not a duplicate.
The probability of collision for MD5 hash is very very low.
And even if the collision occurs, we are hashing length of the line to deal with MD5 collisions




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
