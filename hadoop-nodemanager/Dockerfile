FROM taroull/hadoop:2.8.3

# Web
EXPOSE 8042

ADD https://github.com/lubertorubior/docker-esit/raw/master/jars/hadoop/spark-2.3.0-yarn-shuffle.jar /etc/hadoop

CMD ["yarn", "nodemanager"]
