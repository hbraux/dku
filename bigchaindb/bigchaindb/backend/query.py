"""Query interfaces for backends."""

from functools import singledispatch

from bigchaindb.backend.exceptions import OperationError

VALIDATOR_UPDATE_ID = 'a_unique_id_string'
PRE_COMMIT_ID = 'a_unique_id_string'


@singledispatch
def write_transaction(connection, signed_transaction):
    """Write a transaction to the backlog table.

    Args:
        signed_transaction (dict): a signed transaction.

    Returns:
        The result of the operation.
    """

    raise NotImplementedError


@singledispatch
def store_asset(connection, asset):
    """Write an asset to the asset table.

    Args:
        asset (dict): the asset.

    Returns:
        The result of the operation.
    """

    raise NotImplementedError


@singledispatch
def store_assets(connection, assets):
    """Write a list of assets to the assets table.

    Args:
        assets (list): a list of assets to write.

    Returns:
        The database response.
    """

    raise NotImplementedError


@singledispatch
def store_metadatas(connection, metadata):
    """Write a list of metadata to metadata table.

    Args:
        metadata (list): list of metadata.

    Returns:
        The result of the operation.
    """

    raise NotImplementedError


@singledispatch
def store_transaction(connection, signed_transaction):
    """Same as write_transaction."""

    raise NotImplementedError


@singledispatch
def store_transactions(connection, signed_transactions):
    """Store list of  transactions."""

    raise NotImplementedError


@singledispatch
def get_transaction(connection, transaction_id):
    """Get a transaction from the transactions table.

    Args:
        transaction_id (str): the id of the transaction.

    Returns:
        The result of the operation.
    """

    raise NotImplementedError


@singledispatch
def get_transactions(connection, transaction_ids):
    """Get transactions from the transactions table.

    Args:
        transaction_ids (list): list of transaction ids to fetch

    Returns:
        The result of the operation.
    """

    raise NotImplementedError


@singledispatch
def get_asset(connection, asset_id):
    """Get a transaction from the transactions table.

    Args:
        asset_id (str): the id of the asset

    Returns:
        The result of the operation.
    """

    raise NotImplementedError


@singledispatch
def update_transaction(connection, transaction_id, doc):
    """Update a transaction in the backlog table.

    Args:
        transaction_id (str): the id of the transaction.
        doc (dict): the values to update.

    Returns:
        The result of the operation.
    """

    raise NotImplementedError


@singledispatch
def delete_transaction(connection, *transaction_id):
    """Delete a transaction from the backlog.

    Args:
        *transaction_id (str): the transaction(s) to delete.

    Returns:
        The database response.
    """
    raise NotImplementedError


@singledispatch
def get_stale_transactions(connection, reassign_delay):
    """Get a cursor of stale transactions.

    Transactions are considered stale if they have been assigned a node,
    but are still in the backlog after some amount of time specified in the
    configuration.

    Args:
        reassign_delay (int): threshold (in seconds) to mark a transaction stale.

    Returns:
        A cursor of transactions.
    """

    raise NotImplementedError


@singledispatch
def get_transaction_from_block(connection, transaction_id, block_id):
    """Get a transaction from a specific block.

    Args:
        transaction_id (str): the id of the transaction.
        block_id (str): the id of the block.

    Returns:
        The matching transaction.
    """

    raise NotImplementedError


@singledispatch
def get_transaction_from_backlog(connection, transaction_id):
    """Get a transaction from backlog.

    Args:
        transaction_id (str): the id of the transaction.

    Returns:
        The matching transaction.
    """

    raise NotImplementedError


@singledispatch
def get_blocks_status_from_transaction(connection, transaction_id):
    """Retrieve block election information given a secondary index and value.

    Args:
        value: a value to search (e.g. transaction id string, payload hash string)
        index (str): name of a secondary index, e.g. 'transaction_id'

    Returns:
        :obj:`list` of :obj:`dict`: A list of blocks with with only election information
    """

    raise NotImplementedError


@singledispatch
def get_asset_by_id(conneciton, asset_id):
    """Returns the asset associated with an asset_id.

    Args:
        asset_id (str): The asset id.

    Returns:
        Returns a rethinkdb cursor.
    """

    raise NotImplementedError


@singledispatch
def get_spent(connection, transaction_id, condition_id):
    """Check if a `txid` was already used as an input.

    A transaction can be used as an input for another transaction. Bigchain
    needs to make sure that a given `txid` is only used once.

    Args:
        transaction_id (str): The id of the transaction.
        condition_id (int): The index of the condition in the respective
            transaction.

    Returns:
        The transaction that used the `txid` as an input else `None`
    """

    raise NotImplementedError


@singledispatch
def get_spending_transactions(connection, inputs):
    """Return transactions which spend given inputs

    Args:
        inputs (list): list of {txid, output}

    Returns:
        Iterator of (block_ids, transaction) for transactions that
        spend given inputs.
    """
    raise NotImplementedError


@singledispatch
def get_owned_ids(connection, owner):
    """Retrieve a list of `txids` that can we used has inputs.

    Args:
        owner (str): base58 encoded public key.

    Returns:
        Iterator of (block_id, transaction) for transactions
        that list given owner in conditions.
    """
    raise NotImplementedError


@singledispatch
def get_votes_by_block_id(connection, block_id):
    """Get all the votes casted for a specific block.

    Args:
        block_id (str): the block id to use.

    Returns:
        A cursor for the matching votes.
    """

    raise NotImplementedError


@singledispatch
def get_votes_by_block_id_and_voter(connection, block_id, node_pubkey):
    """Get all the votes casted for a specific block by a specific voter.

    Args:
        block_id (str): the block id to use.
        node_pubkey (str): base58 encoded public key

    Returns:
        A cursor for the matching votes.
    """

    raise NotImplementedError


@singledispatch
def get_votes_for_blocks_by_voter(connection, block_ids, pubkey):
    """Return votes for many block_ids

    Args:
        block_ids (set): block_ids
        pubkey (str): public key of voting node

    Returns:
        A cursor of votes matching given block_ids and public key
    """
    raise NotImplementedError


@singledispatch
def write_block(connection, block):
    """Write a block to the bigchain table.

    Args:
        block (dict): the block to write.

    Returns:
        The database response.
    """

    raise NotImplementedError


@singledispatch
def get_block(connection, block_id):
    """Get a block from the bigchain table.

    Args:
        block_id (str): block id of the block to get

    Returns:
        block (dict): the block or `None`
    """

    raise NotImplementedError


@singledispatch
def get_block_with_transaction(connection, txid):
    """Get a block containing transaction id `txid`

    Args:
        txid (str): id of transaction to be searched.

    Returns:
        block_id (int): the block id or `None`
    """

    raise NotImplementedError


@singledispatch
def write_assets(connection, assets):
    """Write a list of assets to the assets table.

    Args:
        assets (list): a list of assets to write.

    Returns:
        The database response.
    """
    raise NotImplementedError


@singledispatch
def write_metadata(connection, metadata):
    """Write a list of metadata to the metadata table.

    Args:
        metadata (list): a list of metadata to write.

    Returns:
        The database response.
    """
    raise NotImplementedError


@singledispatch
def get_assets(connection, asset_ids):
    """Get a list of assets from the assets table.

    Args:
        asset_ids (list): a list of ids for the assets to be retrieved from
        the database.

    Returns:
        assets (list): the list of returned assets.
    """
    raise NotImplementedError


@singledispatch
def get_metadata(connection, transaction_ids):
    """Get a list of metadata from the metadata table.

    Args:
        transaction_ids (list): a list of ids for the metadata to be retrieved from
        the database.

    Returns:
        metadata (list): the list of returned metadata.
    """
    raise NotImplementedError


@singledispatch
def count_blocks(connection):
    """Count the number of blocks in the bigchain table.

    Returns:
        The number of blocks.
    """

    raise NotImplementedError


@singledispatch
def count_backlog(connection):
    """Count the number of transactions in the backlog table.

    Returns:
        The number of transactions in the backlog.
    """

    raise NotImplementedError


@singledispatch
def write_vote(connection, vote):
    """Write a vote to the votes table.

    Args:
        vote (dict): the vote to write.

    Returns:
        The database response.
    """

    raise NotImplementedError


@singledispatch
def get_genesis_block(connection):
    """Get the genesis block.

    Returns:
        The genesis block
    """

    raise NotImplementedError


@singledispatch
def get_last_voted_block_id(connection, node_pubkey):
    """Get the last voted block for a specific node.

    Args:
        node_pubkey (str): base58 encoded public key.

    Returns:
        The id of the last block the node has voted on. If the node didn't cast
        any vote then the genesis block id is returned.
    """

    raise NotImplementedError


@singledispatch
def get_txids_filtered(connection, asset_id, operation=None):
    """Return all transactions for a particular asset id and optional operation.

    Args:
        asset_id (str): ID of transaction that defined the asset
        operation (str) (optional): Operation to filter on
    """

    raise NotImplementedError


@singledispatch
def get_new_blocks_feed(connection, start_block_id):
    """Return a generator that yields change events of the blocks feed

    Args:
        start_block_id (str): ID of block to resume from

    Returns:
        Generator of change events
    """

    raise NotImplementedError


@singledispatch
def text_search(conn, search, *, language='english', case_sensitive=False,
                diacritic_sensitive=False, text_score=False, limit=0, table=None):
    """Return all the assets that match the text search.

    The results are sorted by text score.
    For more information about the behavior of text search on MongoDB see
    https://docs.mongodb.com/manual/reference/operator/query/text/#behavior

    Args:
        search (str): Text search string to query the text index
        language (str, optional): The language for the search and the rules for
            stemmer and tokenizer. If the language is ``None`` text search uses
            simple tokenization and no stemming.
        case_sensitive (bool, optional): Enable or disable case sensitive
            search.
        diacritic_sensitive (bool, optional): Enable or disable case sensitive
            diacritic search.
        text_score (bool, optional): If ``True`` returns the text score with
            each document.
        limit (int, optional): Limit the number of returned documents.

    Returns:
        :obj:`list` of :obj:`dict`: a list of assets

    Raises:
        OperationError: If the backend does not support text search
    """

    raise OperationError('This query is only supported when running '
                         'BigchainDB with MongoDB as the backend.')


@singledispatch
def get_latest_block(conn):
    """Get the latest commited block i.e. block with largest height """

    raise NotImplementedError


@singledispatch
def store_block(conn, block):
    """Write a new block to the `blocks` table

    Args:
        block (dict): block with current height and block hash.

    Returns:
        The result of the operation.
    """

    raise NotImplementedError


@singledispatch
def store_unspent_outputs(connection, unspent_outputs):
    """Store unspent outputs in ``utxo_set`` table."""

    raise NotImplementedError


@singledispatch
def delete_unspent_outputs(connection, unspent_outputs):
    """Delete unspent outputs in ``utxo_set`` table."""

    raise NotImplementedError


@singledispatch
def delete_transactions(conn, txn_ids):
    """Delete transactions from database

    Args:
        txn_ids (list): list of transaction ids

    Returns:
        The result of the operation.
    """

    raise NotImplementedError


@singledispatch
def get_unspent_outputs(connection, *, query=None):
    """Retrieves unspent outputs.

    Args:
        query (dict): An optional parameter to filter the result set.
            Defaults to ``None``, which means that all UTXO records
            will be returned.

    Returns:
        Generator yielding unspent outputs (UTXO set) according to the
        given query.
    """

    raise NotImplementedError


@singledispatch
def store_pre_commit_state(connection, commit_id, state):
    """Store pre-commit state in a document with `id` as `commit_id`.

    Args:
        commit_id (string): `id` of document where `state` should be stored.
        state (dict): commit state.

    Returns:
        The result of the operation.
    """

    raise NotImplementedError


@singledispatch
def store_validator_update(conn, validator_update):
    """Store a update for the validator set """

    raise NotImplementedError


@singledispatch
def get_pre_commit_state(connection, commit_id):
    """Get pre-commit state where `id` is `commit_id`.

    Args:
        commit_id (string): `id` of document where `state` should be stored.

    Returns:
        Document with `id` as `commit_id`
    """

    raise NotImplementedError


@singledispatch
def get_validator_update(conn):
    """Get validator updates which are not synced"""

    raise NotImplementedError


@singledispatch
def delete_validator_update(conn, id):
    """Set the sync status for validator update documents"""

    raise NotImplementedError
