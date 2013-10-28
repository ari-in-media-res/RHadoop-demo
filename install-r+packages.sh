

# autoconf
wget http://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.xz
tar xvf autoconf-2.69.tar.xz
cd auto*
./configure
sudo make
sudo make install


# set environment variables
cd ~
sudo su << EOF1
cat >> /etc/profile << EOF
export HADOOP_HOME=/usr/lib/hadoop-0.20-mapreduce
export HADOOP_STREAMING=/usr/lib/hadoop-0.20-mapreduce/contrib/streaming/hadoop-streaming-2.0.0-mr1-cdh4.4.0.jar
export HADOOP_CMD=/usr/lib/hadoop-0.20-mapreduce/bin/hadoop

export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig
EOF
EOF1

source /etc/profile

sudo yum -y --enablerepo=epel install R R-devel

sudo R --no-save << EOF
install.packages(c('RJSONIO', 'itertools', 'digest', 'plyr'), repos="http://cran.revolutionanalytics.com", INSTALL_opts=c('--byte-compile') )
EOF


# brooks start

# rmr2
cd ~
wget --no-check-certificate http://goo.gl/RA6VaH
sudo R --no-save << EOF
install.packages(c("Rcpp","bitops","functional", "stringr", "reshape"), repos="http://cran.revolutionanalytics.com")
EOF

sudo R --no-save << EOF
install.packages(c("reshape2"), repos="http://cran.revolutionanalytics.com")
EOF

sudo R --no-save << EOF
install.packages("/home/users/cloudera/rmr2_2.3.0.tar.gz", repos = NULL, type="source")
EOF


#thrift 
cd /home/users/cloudera
echo y | sudo yum install java-1.6.0-openjdk-devel


wget http://apache.osuosl.org/thrift/0.9.1/thrift-0.9.1.tar.gz
tar -xvf thrift*.gz
echo y | sudo yum install automake libtool flex bison pkgconfig gcc-c++ boost-devel libevent-devel zlib-devel python-devel ruby-devel

echo y | sudo yum install openssl-devel


cd ~/thrift*

./configure



sudo make
sudo make install

sudo cp -rf /home/users/cloudera/thrift-0.9.1/lib/cpp/src/thrift/* /usr/local/include



# rhdfs
cd ~

wget --no-check-certificate https://github.com/RevolutionAnalytics/rhdfs/blob/master/build/rhdfs_1.0.7.tar.gz?raw=true


sudo R CMD javareconf
sudo R --no-save << EOF
install.packages(c("rJava"), repos="http://cran.revolutionanalytics.com")
EOF

sudo R --no-save << EOF
Sys.setenv("HADOOP_CMD"="/usr/lib/hadoop-0.20-mapreduce/bin/hadoop")
install.packages("/home/users/cloudera/rhdfs_1.0.7.tar.gz", repos = NULL, type="source")
EOF



# hbase - which requires thrift
cd ~
wget --no-check-certificate https://github.com/RevolutionAnalytics/rhbase/blob/master/build/rhbase_1.2.0.tar.gz?raw=true


sudo cp /usr/local/lib/*thrift* /usr/lib
sudo /sbin/ldconfig /usr/lib/libthrift-0.9.1.so


sudo R --no-save << EOF
Sys.setenv("PKG_CONFIG_PATH"="/usr/local/lib/pkgconfig")
install.packages("/home/users/cloudera/rhbase_1.2.0.tar.gz", repos = NULL, type="source")
EOF



# brooks end

#mv RevolutionAnalytics-RHadoop* RHadoop
#sudo R CMD INSTALL --byte-compile RHadoop/rmr/pkg/

#plyrmr
cd /home/users/cloudera
echo y | sudo yum install curl-devel


sudo R --no-save << EOF
install.packages(c("RCurl"), repos="http://cran.revolutionanalytics.com")
install.packages(c("httr"), repos="http://cran.revolutionanalytics.com")
install.packages(c("devtools"), repos="http://cran.revolutionanalytics.com")
install.packages(c("testthat"), repos="http://cran.revolutionanalytics.com")

library(devtools)
install_github("pryr", "hadley")

EOF

cd /home/users/cloudera
wget --no-check-certificate http://goo.gl/uIi2KS

sudo R --no-save << EOF
install.packages(c("R.methodsS3"), repos="http://cran.revolutionanalytics.com")
install.packages(c("hydroPSO"), repos="http://cran.revolutionanalytics.com")

install.packages("/home/users/cloudera/plyrmr_0.1.0.tar.gz", repos = NULL, type="source")
EOF



