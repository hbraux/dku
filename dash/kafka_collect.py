#!/usr/bin/env python
# -*- coding: utf-8 -*-

# This program needs python3.6+ and packages: kafka-python dash_core_components dash_html_components 
# Run from docker
# docker run -it --rm --network=udn -p 8085:8085 harold.braux/dash /run/result.py



import os
import sys
import json
import uuid
from datetime import datetime, timezone

try:
    import dash
    import dash_core_components as dcc
    import dash_html_components as html
    import plotly.graph_objs as go
    from kafka import KafkaConsumer
except ImportError as err:
    print(err)
    sys.exit(1)


# X and Y points to be displayed
datax = []
datay = []

def read_kafka_json(broker, topic):
    consumer = KafkaConsumer(topic,
                             bootstrap_servers=[broker],
                             group_id=str(uuid.uuid4()),
                             auto_offset_reset='earliest',
                             consumer_timeout_ms=1000)
    print("Reading Kafka topic", topic)
    for msg in consumer:
        j=json.loads(msg.value.decode('ascii'))
        ts= j['create_dt']
        lat=j['out_dt']-ts
        datax.append(datetime.fromtimestamp(ts/1000))
        datay.append(lat) 
    print("Points read",len(datax))

def run_app():
    app = dash.Dash(__name__)
    app.layout = html.Div(children=[
        html.H1(children='Flink Processing Time'),
        dcc.Graph(id='graph', figure={
            'data': [go.Scattergl(x=datax, y=datay, mode='markers')],
            'layout': go.Layout(yaxis={'title': 'ms'})
        })
    ])
    app.run_server(host='0.0.0.0',debug=False)


if __name__ == '__main__':
    if len(sys.argv) < 4:
        print("usage: kafka <broker> <topic>")
        sys.exit(1)
    read_kafka_json(sys.argv[2], sys.argv[3])
    run_app()


