#!/bin/bash
#ii0.8.1.6
# Check if index.html exists
if [ -f "index.html" ]; then
echo "index.html found. Loading existing page..."
else
echo "index.html not found. Creating a new page..."
echo "<html><head><title>Link List</title><meta name="viewport"content="width=device-width" initial-scale="1"><link type="text/css" rel="stylesheet" href="./index.css"> </head><body>" > index.html
fi

# Check if list.txt exists
if [ -f "list.txt" ]; then
echo "list.txt found. Loading existing list..."
else
echo "list.txt not found. Creating a new list..."
echo "list.txt" > list.txt
fi

# Check if checked.txt exists
if [ -f "checked.txt" ]; then
echo "checked.txt found. Loading existing checked list..."
else
echo "checked.txt not found. Creating a new checked list..."
echo "checked.txt" > checked.txt
fi

# Check if list exists
if grep -Fq "<ul>" index.html; then
echo "List found. Appending new links..."
else
echo "<ul>" >> index.html
fi

# Read the list.txt file
while read line; do

# Skip already checked links
if grep -Fxq "$line" checked.txt; then
continue
fi

# Probe the status of websites
wget --timeout=3 --connect-timeout=3 --tries=1 --spider --verbose $line

# If the site is online, index it as a link
if [ $? -eq 0 ]; then
echo "<li><a href="$line">$line</a></li>" >> index.html

# Add the link to the checked list
echo "$line" >> checked.txt

# Move to the next link if connection times out
else
echo "Connection timed out. Moving to the next link..."
fi

done < list.txt


