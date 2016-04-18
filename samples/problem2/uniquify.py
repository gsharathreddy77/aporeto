from optparse import OptionParser
import hashlib

def removeDuplicates(infile, outfile, verbose):
	hashSet = set()
	try:
		fin = open(infile, 'r')
	except IOError:
		if verbose:
			print "Error: can\'t find input file or open it"
	try:
		fout = open(outfile, 'w')
	except IOError:
		if verbose:
			print "Error: can\'t open or create output file"

	try:
		for line in fin:
			line = line.replace("\r\n", "\n").replace("\r", "\n")
			md5Hash = hashlib.md5(line).hexdigest()
			if ((md5Hash, len(line)) not in hashSet):
				hashSet.add((md5Hash, len(line)))
				fout.write(line)
				if verbose:
					print "Wrote: \"" + line + "\" to outputfile"

	except IOError:
		if verbose:
			print "Error: in reading or writing to files"
	fin.close()
	fout.close()

def main():
	parser = OptionParser("usage: %prog --file=<filename> --output=<output-filename> [--verbose]")
	parser.add_option("--file", dest="inputfile", help="Input file from which duplicates has to be removed", metavar="FILE")
	parser.add_option( "--output", dest="outputfile", help="Output file to write unique lines", metavar="FILE")
	parser.add_option("--verbose", action="store_true", dest="verbose", default=False, help="print status messages to stdout")

	(options, args) = parser.parse_args()
	print options

	if not options.inputfile or not options.outputfile:
		parser.error("Incorrect Usage")

	removeDuplicates(options.inputfile, options.outputfile, options.verbose)

if __name__ == '__main__':
    main()