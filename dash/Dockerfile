ARG IMAGE_REPO

FROM ${IMAGE_REPO}/alpine-python

ARG BUILD_PACKAGES=kafka-python

ENV DASH_VERSION 1.0

LABEL sescription "Dash server for graph display"
LABEL USAGE "docker run -it --rm --network=udn -p 8085:8085 ${IMAGE_REPO}/dash"

RUN pip install dash_core_components dash_html_components ${BUILD_PACKAGES/,/ }

EXPOSE 8085

COPY entrypoint.py /

ENTRYPOINT ["/entrypoint.py"]

CMD ["help"]


