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
        for l_key, l_value in parsed_data['node'][key].items():
            graph_key = '{key}.{l_key}'.format(key=key,l_key=l_key)
            if len(l_value) > 1:
                raise Exception('Duplicate node {graph_key}'.format(graph_key=graph_key))
            graph_node = {}
            node_content = l_value[0]
            graph_node["readonly"] = node_content["readonly"] if "readonly" in node_content else False

            graph[graph_key] = graph_node
            # pass # not implemented yet

    # print("Parsed JSON data:")
    # print(parsed_data)
    print(json.dumps(graph, indent=4))
except json.JSONDecodeError as e:
    print("Error decoding JSON:", str(e))
