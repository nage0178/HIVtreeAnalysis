#!/bin/bash

sed -E 's/:[0-9.Ee-]+//g' $1 > $2
