#!/usr/bin/env python
# -*- coding: utf-8 -*-
# This program needs python3.6+ and kafka-python
#
# Generic JSON message producer
# Expected arguments: broker(s), topic, message (quoted JSON)
#
# The message can contain tags such as %UUID, %STRl, %INTn which respectively
# generate a random UUID, String of length l and INT betwenn 0 and n
# Example: {"uuid":"%UUID","pkey":"%STR3","skey":"%STR4","value":%INT9999}

import os
import sys
import json
import re
import uuid
import random
import time
import string
from datetime import datetime

try:
    from kafka import KafkaProducer, KafkaConsumer
except ImportError as err:
    print(err)
    sys.exit(1)

Debug = False  # Debug output the message to console
Delay = 10     # default delay in ms
Count = sys.maxsize  
Dump = None    # dump a topic to console


def usage(exitcode):
    print("""# Generic JSON message producer
Usage: kafka-json.py [options] <broker(s)> <topic> <json msg>

Options
  --debug (print to stdout only)
  --delay INT (ms)
  --seed INT
  --count INT
  --dump FORMAT (dump JSON messages from a topic, supported format: json csv)
""")
    sys.exit(exitcode)


def kafka_gen(brokers, topic, template):
    tags = re.findall("%[A-Z]+[0-9]*", template)
    funcs = []
    # double the brackets to support format function
    template = template.replace("{", "{{").replace("}", "}}")
    for tag in tags:
        template = template.replace(tag, "{}", 1)
        if (tag == "%UUID"):
            funcs.append(lambda: str(uuid.uuid4()))
        elif (tag[0:4] == "%INT"):
            n = int(tag[4:]) + 1
            funcs.append(lambda n=n: random.randint(0, n))
        elif (tag[0:4] == "%STR"):
            n = int(tag[4:])
            funcs.append(lambda n=n:
                         "".join(random.choices(string.ascii_uppercase, k=n)))
        else:
            raise Exception("unknown tag", tag)
    if not Debug:
        producer = KafkaProducer(bootstrap_servers=brokers,
                                 value_serializer=lambda m:
                                 json.dumps(m).encode('ascii'))
    cnt = 0
    while cnt < Count:
        args = [f() for f in funcs]
        j = json.loads(template.format(*args))
        if Debug:
            print(str(j).replace("'","\""))
        else:
            producer.send(topic, j)
        time.sleep(Delay/1000.0)
        cnt += 1
        if not Debug and cnt % 1000 == 0:
            now = datetime.now().strftime("%H:%M:%S")
            print(now, cnt, "message posted on topic:", topic,
                  "(type CTRL^C to stop the process)")
    producer.flush()

def kafka_dump(brokers, topic):
    consumer = KafkaConsumer(
        topic,
        bootstrap_servers=brokers,
        group_id=None,
        auto_offset_reset='earliest',
        enable_auto_commit=False,
        value_deserializer=lambda m:json.loads(m.decode('ascii')),
        consumer_timeout_ms=1000)
    for msg in consumer:
        if Dump == 'json':
            print(str(msg.value).replace("'","\""))
        elif Dump == 'csv':
            print(",".join([str(v) for k, v in msg.value.items()]))
        else:
            raise Exception("unsupported dump format", Dump)

        
if __name__ == '__main__':
    argp = 1
    if (len(sys.argv) == 0):
        usage(0)
    while len(sys.argv) > argp and sys.argv[argp][0:2] == "--":
        if sys.argv[argp] == "--debug":
            Debug = True
            argp += 1
        elif sys.argv[argp] == "--delay":
            Delay = int(sys.argv[argp+1])
            argp += 2
        elif sys.argv[argp] == "--count":
            Count = int(sys.argv[argp+1])
            argp += 2
        elif sys.argv[argp] == "--seed":
            random.seed(int(sys.argv[argp+1]))
            argp += 2 
        elif sys.argv[argp] == "--dump":
            Dump = sys.argv[argp+1]
            argp += 2 
    if Dump:
        if len(sys.argv) < argp+2:
            usage(1)
        kafka_dump(sys.argv[argp].split(","), sys.argv[argp+1])
    else:
        if len(sys.argv) < argp+3:
            usage(1)
        kafka_gen(sys.argv[argp].split(","), sys.argv[argp+1],
                  sys.argv[argp+2])
