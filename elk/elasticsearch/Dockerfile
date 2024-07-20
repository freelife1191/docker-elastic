ARG ELASTIC_VERSION

# https://www.docker.elastic.co/
FROM docker.elastic.co/elasticsearch/elasticsearch:${ELASTIC_VERSION}
# FROM amazon/opendistro-for-elasticsearch:1.13.3

#COPY sysctl.conf /etc/sysctl.conf

#RUN sysctl -w vm.max_map_count=262144 \
#    && sysctl -w s.file-max=131072 \
#    && sysctl -w vm.swappiness=1

# Add your elasticsearch plugins setup here
# Example: RUN elasticsearch-plugin install analysis-icu
RUN elasticsearch-plugin install analysis-icu
RUN elasticsearch-plugin install analysis-nori

# https://opendistro.github.io/for-elasticsearch-docs/docs/install/plugins/
# https://opendistro.github.io/for-elasticsearch-docs/docs/install/docker/
COPY alerting.zip /tmp/
RUN elasticsearch-plugin install -b file:///tmp/alerting.zip
# RUN elasticsearch-plugin install -b https://github.com/opendistro-for-elasticsearch/alerting/releases/download/v1.13.1.0/alerting.zip

# https://github.com/netcrazy/elasticsearch-jaso-analyzer
#RUN elasticsearch-plugin install -b https://github.com/freelife1191/docker-elastic/blob/main/elk/elasticsearch/jaso-analyzer-plugin-7.10.2-plugin.zip
COPY jaso-analyzer-plugin-7.10.2-plugin.zip /tmp/
RUN elasticsearch-plugin install file:///tmp/jaso-analyzer-plugin-7.10.2-plugin.zip