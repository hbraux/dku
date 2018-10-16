# Dash https://dash.plot.ly/

FROM dku/python-builder:3.6

ENV DASH_VERSION 0.28

LABEL Description="Dash server"

RUN pip install pandas fastavro requests dash dash-html-components dash-core-components


COPY bWLwgP.css /
COPY app.py /


EXPOSE 8050

CMD "python app.py"
