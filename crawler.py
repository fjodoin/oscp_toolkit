#!/usr/bin/python

# Import necessary modules
import sys
import json
import requests
import argparse
from bs4 import BeautifulSoup

# Define a function 'results' that reads a JSON file and extracts URLs from it.
def results(file):
    content = open(file, 'r').readlines()
    for line in content:
        data = json.loads(line.strip())
    urls = []
    for url in data['results']:
        urls.append(url['url'])
    return urls

# Define a function 'crawl' to retrieve and parse HTML content from a given URL.
def crawl(url):
    r = requests.get(url)
    soup = BeautifulSoup(r.text, 'html.parser')
    links = soup.findAll('a', href=True)
    for link in links:
        link = link['href']
        if link and link != '#':
            print('[+] {} : {}'.format(url, link))

# Check if the script is being run as the main program.
if __name__ == "__main__":
    # Create an argument parser to accept a file as input.
    parser = argparse.ArgumentParser()
    parser.add_argument("file", help="ffuf results")  # Argument for specifying the input file.
    args = parser.parse_args()  # Parse command line arguments.
    urls = results(args.file)  # Extract URLs from the JSON file specified in the command line.
    
    # Iterate through the extracted URLs and crawl each of them.
    for url in urls:
        crawl(url)
