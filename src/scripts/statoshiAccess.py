import requests
transactions_start = 1563451000
transactions_end = 1563454759
response = requests.get(
            f'http://35.222.78.151/render?'
            f'target=stats.transactions.accepted&'
            f'from={transactions_start}&until='
            f'{transactions_end}&format=json')
print(response.json())