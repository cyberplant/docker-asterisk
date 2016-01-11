# Dockerized Asterisk

This is a dockerized version of [asterisk](http://www.asterisk.org).

# What is asterisk?

According to www.asterisk.org:

Asterisk is an open source framework for building communications applications. Asterisk turns an ordinary computer into a communications server.

# How can I use this docker image?

```

docker run -d --name asterisk -v <config directory>:/etc/asterisk luar/asterisk

```
