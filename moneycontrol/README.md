# MoneyControl

This Ruby project scrapes dynamic stock recommendation data (stock ideas) from [MoneyControl](https://www.moneycontrol.com/) using Selenium WebDriver and Nokogiri. The tool automates browser scrolling to capture dynamically loaded data, parses it, and stores structured results in a CSV file.

## Tech Stack

- Ruby
- Selenium WebDriver
- Nokogiri
- CSV
- ChromeDriver

## Features

- Scrapes stock recommendation cards indexed by position and grouped by date.
- Handles infinite scroll behavior to load additional stock data.
- Extracts and cleans data using Nokogiri for HTML parsing.
- Saves the final output to a CSV file with meaningful column structure.
- Designed for resilience and scalability.