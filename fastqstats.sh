# fastqstats.sh --basic FASTQ statistics
#
# input: fastq file
# output: fastq; total reads; unique reads; most abundant sequence; abundant sequence count
# modified from https://github.com/stephenturner/oneliners/blob/master/README.md 
# isradelacon@gmail.com 2014-11-18
echo -n "$1 "
cat $1 | awk '((NR-2)%4==0){read=$1;total++;count[read]++}END{for(read in count){if(!max||count[read]>max) {max=count[read];maxRead=read};if(count[read]==1){unique++}};print total,unique,maxRead,count[maxRead]}'
