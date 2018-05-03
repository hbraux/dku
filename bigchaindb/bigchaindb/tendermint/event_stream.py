import asyncio
import json
import logging
import time
from os import getenv

import aiohttp

from bigchaindb.common.utils import gen_timestamp
from bigchaindb.events import EventTypes, Event
from bigchaindb.tendermint.utils import decode_transaction_base64


HOST = getenv('BIGCHAINDB_TENDERMINT_HOST', 'localhost')
PORT = int(getenv('BIGCHAINDB_TENDERMINT_PORT', 46657))
URL = 'ws://{}:{}/websocket'.format(HOST, PORT)

logger = logging.getLogger(__name__)


@asyncio.coroutine
def connect_and_recv(event_queue):
    session = aiohttp.ClientSession()
    ws = yield from session.ws_connect(URL)

    logger.info('Connected to tendermint ws server')

    stream_id = 'bigchaindb_stream_{}'.format(gen_timestamp())
    yield from subscribe_events(ws, stream_id)

    while True:
        msg = yield from ws.receive()
        process_event(event_queue, msg.data, stream_id)

        if msg.type in (aiohttp.WSMsgType.CLOSED,
                        aiohttp.WSMsgType.ERROR):
            session.close()
            raise aiohttp.ClientConnectionError()


def process_event(event_queue, event, stream_id):
    event_stream_id = stream_id + '#event'
    event = json.loads(event)

    if (event['id'] == event_stream_id and event['result']['name'] == 'NewBlock'):
        block = event['result']['data']['data']['block']
        block_id = block['header']['height']
        block_txs = block['data']['txs']

        # Only push non empty blocks
        if block_txs:
            block_txs = [decode_transaction_base64(txn) for txn in block_txs]
            new_block = {'height': block_id, 'transactions': block_txs}
            event = Event(EventTypes.BLOCK_VALID, new_block)
            event_queue.put(event)


@asyncio.coroutine
def subscribe_events(ws, stream_id):
    payload = {
        'method': 'subscribe',
        'jsonrpc': '2.0',
        'params': ['NewBlock'],
        'id': stream_id
    }
    yield from ws.send_str(json.dumps(payload))


@asyncio.coroutine
def try_connect_and_recv(event_queue, max_tries):
    try:
        yield from connect_and_recv(event_queue)

    except Exception as e:
        if max_tries:
            logger.warning('WebSocket connection failed with exception %s', e)
            time.sleep(3)
            yield from try_connect_and_recv(event_queue, max_tries-1)
        else:
            logger.exception('WebSocket connection failed with exception %s', e)


def start(event_queue):
    loop = asyncio.get_event_loop()
    try:
        loop.run_until_complete(try_connect_and_recv(event_queue, 10))
    except (KeyboardInterrupt, SystemExit):
        logger.info('Shutting down Tendermint event stream connection')
