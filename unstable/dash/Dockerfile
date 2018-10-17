# Dash https://dash.plot.ly/

FROM dku/python-builder:3.6

ENV DASH_VERSION 0.28

LABEL Description="Dash server"

RUN pip install fastavro requests numpy
RUN pip install dash dash-html-components dash-core-components


# URL and auth
ENV SITE_KNOX
ENV SITE_KNOX_AUTH

ENV HBASE_TABLE

COPY bWLwgP.css /
COPY app.py /


EXPOSE 8050

CMD "python app.py"
