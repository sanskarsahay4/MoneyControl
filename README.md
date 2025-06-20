# Web Scraping Projects

- This repository contains a collection of web scraping projects developed using Ruby, Selenium WebDriver, and Nokogiri.
- Each subfolder includes a standalone scraper that extracts data from a specific finance-related website.

## Money Control

- This project scrapes the latest stock recommendations from MoneyControl's stock ideas page (https://www.moneycontrol.com/markets/stock-ideas/).
- Handles dynamic content loading to collect stock idea cards.

### Groww

- This project extracts stock data from Groww’s stock screener page (https://groww.in/stocks/filter).
- The script handles pagination to systematically navigate through all available pages of stock listings, applying filters such as Sector, Index, Market Cap (Cr), and Close Price.
- Key information — including company name, industry, market capitalization, and current stock price — is extracted and saved into a structured CSV file for further analysis.
