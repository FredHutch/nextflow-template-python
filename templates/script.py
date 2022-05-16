#!/usr/bin/env python3

import pandas as pd

# Read in the input CSV file
# Note that ${input_csv} is replaced by the path to the input file in the
# current working directory by the Nextflow controller prior to runtime
print("Reading in ${input_csv}")
df = pd.read_csv("${input_csv}")

# Add the prefix string
print("Adding the prefix to all cells in the CSV ${params.string_to_append}")
df = df.applymap(
    lambda s: f"${params.string_to_append}{s}"
)

# Save the output
df.to_csv(
    "${input_csv}.appended.csv",
    index=None
)