import requests
transactions_start = 1563451000
transactions_end = 1563454759
transactions_accepted = requests.get(
            f'http://35.222.78.151/render?'
            f'target=stats.transactions.accepted&'
            f'from={transactions_start}&until='
            f'{transactions_end}&format=json')
blocks = requests.get(
            f'http://35.222.78.151/render?'
            f'target=stats.blocks.size&'
            f'from={blocks_start}&until='
            f'{blocks_end}&format=json')
mempool_TNX = requests.get(
            f'http://35.222.78.151/render?'
            f'target=stats.mempool.transactions&'
            f'from={mempool_start}&until='
            f'{mempool_end}&format=json')

print(response.json())