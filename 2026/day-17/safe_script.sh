#!/bin/bash

set -e

mkdir /tmp/devops-test || echo "dir already exists"

cd /tmp/devops-test || {
	echo "Cannot enter dir"
	exit 1
}

touch demo.txt

echo "File create successfully"
