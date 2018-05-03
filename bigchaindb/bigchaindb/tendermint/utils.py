import base64
import json
from binascii import hexlify

try:
    from hashlib import sha3_256
except ImportError:
    from sha3 import sha3_256


def encode_transaction(value):
    """Encode a transaction (dict) to Base64."""

    return base64.b64encode(json.dumps(value).encode('utf8')).decode('utf8')


def decode_transaction(raw):
    """Decode a transaction from bytes to a dict."""

    return json.loads(raw.decode('utf8'))


def decode_transaction_base64(value):
    """Decode a transaction from Base64."""

    return json.loads(base64.b64decode(value.encode('utf8')).decode('utf8'))


def calculate_hash(key_list):
    if not key_list:
        return ''

    full_hash = sha3_256()
    for key in key_list:
        full_hash.update(key.encode('utf8'))

    return full_hash.hexdigest()


def merkleroot(hashes):
    """
    Computes the merkle root for a given list.

    Args:
        hashes (:obj:`list` of :obj:`bytes`): The leaves of the tree.

    Returns:
        str: Merkle root in hexadecimal form.

    """
    # XXX TEMPORARY -- MUST REVIEW and possibly CHANGE
    # The idea here is that the UTXO SET would be empty and this function
    # would be invoked to compute the merkle root, and since there is nothing,
    # i.e. an empty list, then the hash of the empty string is returned.
    # This seems too easy but maybe that is good enough? TO REVIEW!
    if not hashes:
        return sha3_256(b'').hexdigest()
    # XXX END TEMPORARY -- MUST REVIEW ...
    if len(hashes) == 1:
        return hexlify(hashes[0]).decode()
    if len(hashes) % 2 == 1:
        hashes.append(hashes[-1])
    parent_hashes = [
        sha3_256(hashes[i] + hashes[i+1]).digest()
        for i in range(0, len(hashes)-1, 2)
    ]
    return merkleroot(parent_hashes)
