# Script to fix csv files from statoshi
import sys

# Open file from first argument
file_r = open(sys.argv[1], "rt")
# Create a new csv file with the second argument
file_w = open("data/processed/" + str(sys.argv[2]) + ".csv", "w+")

# Function to replace a semi-colon with a comma
def replace_colon(char):
    if(char == ';'):
        char = ','
    file_w.write(char)

# Main - replace all the semi-colons wiht commas
for line in file_r.read():
    for c in line:
        replace_colon(c)