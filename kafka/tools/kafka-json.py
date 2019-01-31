#!/usr/bin/env python
# -*- coding: utf-8 -*-
# This program needs python3.6+ and kafka-python 
#
# Generic JSON message producer
# Expected arguments:
#  1) broker
#  2) topic
#  3) delay (between each message in in ms)
#  4) JSON message
# The JSON can contain tags such as %UUID, %STRl, %INTnnnn which respectivly
# generate a random UUID, String of length l and INT betwenn 0 and nnnn

# TODO: multiple brokers, delay as an option, help, debug mode

import os
import sys
import json
import re
import uuid
import random
import time
import string
from datetime  import datetime 

try:
    from kafka import KafkaProducer
except ImportError as err:
    print(err)
    sys.exit(1)

def kafka_gen(brokers, topic, delay, template):
    tags = re.findall("%[A-Z]+[0-9]*",template)
    funcs = [] 
    # double the brackets to support format function
    template = template.replace("{","{{").replace("}","}}")
    for tag in tags:
        template = template.replace(tag,"{}",1)
        if (tag == "%UUID"):
            funcs.append(lambda: str(uuid.uuid4()))
        elif (tag[0:4] == "%INT"):
            n = int(tag[4:]) + 1
            funcs.append(lambda n=n: random.randint(0, n))
        elif (tag[0:4] == "%STR"):
            n = int(tag[4:])
            funcs.append(lambda n=n: "".join(random.choices(string.ascii_uppercase, k=n)))
        else:
            raise Exception("unknown tag", tag)
    if brokers:
        producer = KafkaProducer(bootstrap_servers=[brokers], value_serializer=lambda m: json.dumps(m).encode('ascii'))
    count = 0
    while(True):
        if count % 1000 == 0:
            now = datetime.now().strftime("%H:%M:%S")
            print(now, count, "message posted on topic: ", topic ,
                  "(type CTRL^C to stop the process)")
        args = [ f() for f in funcs ]
        j = json.loads(template.format(*args))
        if brokers:
            producer.send(topic, j)
        else:
            print("#TEST: ",j)
        time.sleep(delay)
        count = count + 1

if __name__ == '__main__':
    if (len(sys.argv) > 1 and sys.argv[1] == "--test"):
        kafka_gen(None, "out", 1/1000.0,
                  '{"uuid":"%UUID","pkey":"%STR3","skey":"%STR4","value":%INT99999}')
        sys.exit(0)
    if len(sys.argv) < 4:
        print("usage: kafka-json.py <broker> <topic> <delay (ms)> <json msg>")
        sys.exit(1)
    kafka_gen(sys.argv[1], sys.argv[2], int(sys.argv[3])/1000.0, sys.argv[4])
    


