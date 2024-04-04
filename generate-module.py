#!/usr/bin/env python

# -*- coding: utf-8 -*-
import sys
import json

# Read all lines from stdin
input_data = sys.stdin.read()
graph = {}

# Parse the JSON data
try:
    parsed_data = json.loads(input_data)
    for key, value in parsed_data['node'].items():
        node_resource = key
        for l_key, l_value in parsed_data['node'][key].items():
            pass # not implemented yet

    print("Parsed JSON data:")
    print(parsed_data)
except json.JSONDecodeError as e:
    print("Error decoding JSON:", str(e))
