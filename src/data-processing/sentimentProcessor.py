# Module providing functions required for sentiment analysis
##
# Function to output a value based on the vader score of a string
def sentimentThreshold(sentiment):
    if (sentiment > 0.5):
        return 1
    elif (sentiment < -0.5):
        return 0
    else:
        return 2

# Function to calculate the change in sentiment from previous value in a pandas row
def sentimentDelta(row):
    if (row.shift(1)["com"].isnull()):
        row["sent_delta"] = 0
    else:
        row["sent_delta"] = row["com"]= row.shift(1)["com"]

