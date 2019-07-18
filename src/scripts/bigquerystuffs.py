# Import relevant libraries
import pandas as pd
from pandas.io import gbq
from google.cloud import bigquery
from google.oauth2 import service_account
from google.cloud import langauge

credentials = service_account.Credentials.from_service_account_file("/Users/elijahrou/Google Drive/iX/BTC_Blockchain_Analysis/bigquery_service_key.json")
project_id = "ethereum-data-exploration"
client = bigquery.Client(project = project_id, credentials=credentials)

top10_active_users_query = """
SELECT
  DATEPART,
  count(author) as Stories
FROM
  [fh-bigquery:hackernews.stories]
GROUP BY
  User
ORDER BY
  Stories DESC
LIMIT
  10
"""

try:
    top10_active_users_df = gbq.read_gbq(top10_active_users_query, project_id=project_id)
except:
    print("Error reading the dataset")


