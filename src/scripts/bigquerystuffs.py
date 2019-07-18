# Import relevant libraries
import pandas as pd
from pandas.io import gbq
from google.cloud import bigquery

client = bigquery.Client()

import plotly.plotly as pt
import plotly.graph_objs as go
import plotly.figure_factory as ff

project_id = "playproject-247013"

top10_active_users_query = """
SELECT
  author AS User,
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

top_10_users_table = ff.create_table(top10_active_users_df)
print(top10_active_users_df.head())
pt.plot(top_10_users_table, filename='top-10-active-users')

