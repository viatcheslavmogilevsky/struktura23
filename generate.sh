#!/bin/bash

echo "Hello"

# cat $@ | hcl2json | jq .


# cat $@ | hcl2json | generate-module.py --out examples/generated-modules/eks-with-nodes