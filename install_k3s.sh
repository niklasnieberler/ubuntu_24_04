#!/bin/bash

curl -sfL https://get.k3s.io | sh - 

kubectl config view --minify --raw
