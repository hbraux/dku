#!/usr/bin/env python
# -*- coding: utf-8 -*-
# Collect data from kafka topics
# 
# This program needs python3.6+ and kafka-python
# Can be used in standalone mode or invoked by another py script

# testing from Docker(dku): docker run -it --rm -e PACKAGES=kafka-python --network=udn -v $(pwd):/mnt $USER/alpine-python /mnt/kafka_collector.py


import os
import sys
import json
from datetime import datetime

try:
    from kafka import KafkaConsumer
except ImportError as err:
    print(err)
    sys.exit(1)


Format = 'JSON'

# Collects the timestamp differences between and input and output topic
# result is a list of pairs (timestamp, delay in ms)
# Assumes that each message is a JSON containing a UUID in first position

def kafka_diff(brokers, topic_in, topic_out):
    ts_in = {}
    data = []
    consumer = KafkaConsumer(
        topic_in,
        bootstrap_servers=brokers,
        group_id=None,
        auto_offset_reset='earliest',
        enable_auto_commit=False,
        value_deserializer=lambda m:json.loads(m.decode('ascii')),
        consumer_timeout_ms=1000)
    print("Reading Kafka topic", topic_in)
    cnt = 0
    for msg in consumer:
        key = list(msg.value)[0]
        ts_in[msg.value[key]] = msg.timestamp
        cnt += 1
    print(cnt, "messages read")
    consumer = KafkaConsumer(
        topic_out,
        bootstrap_servers=brokers,
        group_id=None,
        auto_offset_reset='earliest',
        enable_auto_commit=False,
        value_deserializer=lambda m:json.loads(m.decode('ascii')),
        consumer_timeout_ms=1000)
    print("Reading Kafka topic", topic_out)
    cnt = 0
    for msg in consumer:
        key = list(msg.value)[0]
        uuid = msg.value[key]
        if ts_in[uuid]:
            data.append([datetime.fromtimestamp(ts_in[uuid]/1000.0),
                         msg.timestamp-ts_in[uuid]])
            cnt += 1
    print(cnt, "messages read and reconciled with input data")
    return data


if __name__ == '__main__':
    if len(sys.argv) < 4:
        print("usage: kafka_collector.py <brokers> <topic> <topic>")
        sys.exit(1)
    data = kafka_diff(sys.argv[1].split(","), sys.argv[2], sys.argv[3])
    print("---------------")
    for d in data:
        print(d[0],d[1])



