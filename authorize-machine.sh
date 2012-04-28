#!/bin/bash
scp -P 222 ~/.ssh/authorized_keys $1:~/.ssh/
