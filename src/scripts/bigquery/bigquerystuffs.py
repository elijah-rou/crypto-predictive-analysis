# Import relevant libraries
import pandas as pd
from pandas.io import gbq
from google.cloud import bigquery
from google.oauth2 import service_account



credentials = service_account.Credentials.from_service_account_file("/Users/elijahrou/Google Drive/iX/BTC_Blockchain_Analysis/src/scripts/bigquery/bigquery_service_key.json")
project_id = "ethereum-data-exploration"
client = bigquery.Client(project = project_id, credentials=credentials)

blockQuery = "SELECT * FROM `bigquery-public-data.crypto_bitcoin.blocks`"
query_job = client.query(blockQuery)
iterator = query_job.result(timeout=30)
rows = list(iterator)

blocks = pd.DataFrame(data=[list(x.values()) for x in rows], columns = list(rows[0].keys()))
blocks.rename(columns={'Unnamed: 0':"block#"}, inplace=True)

blocks.to_csv("data/btc_blockchain_all/blocks.csv")


