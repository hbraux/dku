import logging

import setproctitle

import bigchaindb
from bigchaindb.tendermint.lib import BigchainDB
from bigchaindb.tendermint.core import App
from bigchaindb.web import server, websocket_server
from bigchaindb.tendermint import event_stream
from bigchaindb.events import Exchange, EventTypes
from bigchaindb.utils import Process


logger = logging.getLogger(__name__)

BANNER = """
****************************************************************************
*                                                                          *
*   ┏┓ ╻┏━╸┏━╸╻ ╻┏━┓╻┏┓╻╺┳┓┏┓    ┏━┓ ┏━┓ ╺┳┓┏━╸╻ ╻                         *
*   ┣┻┓┃┃╺┓┃  ┣━┫┣━┫┃┃┗┫ ┃┃┣┻┓   ┏━┛ ┃┃┃  ┃┃┣╸ ┃┏┛                         *
*   ┗━┛╹┗━┛┗━╸╹ ╹╹ ╹╹╹ ╹╺┻┛┗━┛   ┗━╸╹┗━┛╹╺┻┛┗━╸┗┛                          *
*   codename "fluffy cat"                                                  *
*   Initialization complete. BigchainDB Server is ready and waiting.       *
*                                                                          *
*   You can send HTTP requests via the HTTP API documented in the          *
*   BigchainDB Server docs at:                                             *
*    https://bigchaindb.com/http-api                                       *
*                                                                          *
*   Listening to client connections on: {:<15}                    *
*                                                                          *
****************************************************************************
"""


def start():
    # Exchange object for event stream api
    exchange = Exchange()

    # start the web api
    app_server = server.create_server(
        settings=bigchaindb.config['server'],
        log_config=bigchaindb.config['log'],
        bigchaindb_factory=BigchainDB)
    p_webapi = Process(name='webapi', target=app_server.run)
    p_webapi.start()

    # start message
    logger.info(BANNER.format(bigchaindb.config['server']['bind']))

    # start websocket server
    p_websocket_server = Process(name='ws',
                                 target=websocket_server.start,
                                 args=(exchange.get_subscriber_queue(EventTypes.BLOCK_VALID),))
    p_websocket_server.start()

    # connect to tendermint event stream
    p_websocket_client = Process(name='ws_to_tendermint',
                                 target=event_stream.start,
                                 args=(exchange.get_publisher_queue(),))
    p_websocket_client.start()

    p_exchange = Process(name='exchange', target=exchange.run)
    p_exchange.start()

    # We need to import this after spawning the web server
    # because import ABCIServer will monkeypatch all sockets
    # for gevent.
    from abci import ABCIServer

    setproctitle.setproctitle('bigchaindb')

    app = ABCIServer(app=App())
    app.run()


if __name__ == '__main__':
    start()
