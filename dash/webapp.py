#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import sys

try:
    import dash
    import dash_core_components as dcc
    import dash_html_components as html
    import plotly.graph_objs as go
    from kafka_collector import kafka_diff
except ImportError as err:
    print(err)
    sys.exit(1)


def display(data, title, xlabel, ylabel):
    app = dash.Dash(__name__)
    app.layout = html.Div(children=[
        html.H1(children=title),
        dcc.Graph(id='graph', figure={
            'data': [go.Scattergl(x=list(zip(*data))[0],
                                  y=list(zip(*data))[1],
                                  mode='markers')],
            'layout': go.Layout(xaxis={'title': xlabel},
                                yaxis={'title': ylabel})
        })
    ])
    app.run_server(host='0.0.0.0',debug=False)


if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("usage: webapp.py COLLECTOR ARGS..")
        sys.exit(1)
    collector = sys.argv[1]
    if (collector == 'kafka'):
        display(kafka_diff(sys.argv[2], sys.argv[3], sys.argv[4]),
                "Kafka Processing Time" + sys.argv[3] + "->" + sys.argv[4],
                "date","ms")
    else:
        raise Exception("unknown collector", collector)


