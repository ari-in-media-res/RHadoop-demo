
# Author: Ralph Brooks
# This is a simple script that runs map reduce on CDH4

Sys.setenv("HADOOP_HOME"="/usr/lib/hadoop-0.20-mapreduce")
Sys.setenv("HADOOP_STREAMING"="/usr/lib/hadoop-0.20-mapreduce/contrib/streaming/hadoop-streaming-2.0.0-mr1-cdh4.3.0.jar")
Sys.setenv("HADOOP_CMD"="/usr/lib/hadoop-0.20-mapreduce/bin/hadoop")

Sys.setenv("HADOOP_CLASSPATH"="/etc/hadoop/conf:/usr/lib/hadoop/lib/*:/usr/lib/hadoop/.//*:/usr/lib/hadoop-hdfs/./:/usr/lib/hadoop-hdfs/lib/*:/usr/lib/hadoop-hdfs/.//*:/usr/lib/hadoop-yarn/lib/*:/usr/lib/hadoop-yarn/.//*:/usr/lib/hadoop-0.20-mapreduce/./:/usr/lib/hadoop-0.20-mapreduce/lib/*:/usr/lib/hadoop-0.20-mapreduce/.//*")


#Sys.setenv("PATH"="/sbin:/usr/sbin:/bin:/usr/bin")   #bash fails without this
#Sys.setenv("JAVA_HOME"="/usr/java/jdk1.6.0_32")

library(rJava)
library(rmr2)


map <- function (k, lines){
  
  fields <- unlist(strsplit(lines, '\\,')

  if (!(identical(fields[[1]], "Year")) & length(fields) == 29){
  
    deptDelay <- fields[[16]]
    # Skip records where departure dalay is "NA":
    if (!(identical(deptDelay, "NA"))) {
      # field[9] is carrier, field[1] is year, field[2] is month:
      carrierID <- paste(fields[[9]], "|", fields[[1]], "|", fields[[2]], sep="")
      delay <- deptDelay
      
      return(keyval(carrierID, delay))
    
    }
  }
                   

  
}

reduce <- function (word, counts){
  
  keyval(word, sum(counts))
  
}

wordcount <- function (input, output=NULL){
  mapreduce(input=input, output=output, input.format="text", map=map, reduce=reduce)
  
  
}


hdfs.root <- 'asa-airline'
hdfs.data <- file.path(hdfs.root, 'data')
hdfs.out <- file.path(hdfs.root, 'out')
out <- wordcount(hdfs.data, hdfs.out)

results <- from.dfs(out)
results.df <- as.data.frame(results, stringsAsFactors=F)
colnames(results.df) <- c('word', 'count')
head(results.df)
