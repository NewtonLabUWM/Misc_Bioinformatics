
#########################################################
### remove line breaks that occur within FASTA sequences
### (occured when downloading contigs from NCBI; new line
###  at every 80bp)
### Lou LaMartina, May 6 2021
#########################################################




### SOURCE ###

# https://stackoverflow.com/questions/15857088/remove-line-breaks-in-a-fasta-file

# On lines that don't start with a >, 
#    print the line without a line break 
#    and store a newline character (in variable n) for later.

# On lines that do start with a >, 
#    print the stored newline character (if any) and the line. 
#    Reset n, in case this is the last line.

# End with a newline, if required.




### INSTRUCTIONS ###

# make executable!
# $ chmod u+x fastaToCSV.sh

# then:
# $ ./removeLineBreakFASTA.sh FILE_NAME.fasta




for file in $@; do
	awk '!/^>/ { printf "%s", $0; n = "\n" } 
		/^>/ { print n $0; n = "" }
		END { printf "%s", n }
		' "$@" > strip_$@
done
