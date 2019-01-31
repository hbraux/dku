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
    from kafka import KafkaProducer
except ImportError as err:
    print(err)
    sys.exit(1)

Debug = False  # Debug output the message to console
Delay = 10     # default delay


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
        producer = KafkaProducer(bootstrap_servers=brokers.split(","),
                                 value_serializer=lambda m:
                                 json.dumps(m).encode('ascii'))
    count = 0
    while(True):
        if not Debug and count % 1000 == 0:
            now = datetime.now().strftime("%H:%M:%S")
            print(now, count, "message posted on topic: ", topic,
                  "(type CTRL^C to stop the process)")
        args = [f() for f in funcs]
        j = json.loads(template.format(*args))
        if Debug:
            print("#", j)
        else:
            producer.send(topic, j)
        time.sleep(Delay/1000.0)
        count += 1


if __name__ == '__main__':
    argp = 1
    if (len(sys.argv) > argp and sys.argv[argp] == "--debug"):
        Debug = True
        argp += 1
    if (len(sys.argv) > argp+1 and sys.argv[argp] == "--delay"):
        Delay = int(sys.argv[argp+1])
        argp += 2
    if len(sys.argv) < argp+3:
        print("""
Usage: kafka-json.py [options] <broker(s)> <topic> <json msg>

Options
  --debug
  --delay ms
""")
        sys.exit(1)
    kafka_gen(sys.argv[argp], sys.argv[argp+1], sys.argv[argp+2])
