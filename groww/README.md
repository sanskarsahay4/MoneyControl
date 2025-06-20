# Groww

This Ruby-based project scrapes stock data from the Groww Stock Screener page (https://groww.in/stocks/filter) using Selenium WebDriver and Nokogiri. It applies custom filters like sectors, indices, market cap, and close price, and extracts relevant stock data into a clean CSV file.

## Features

- Automates the Groww Stock Screener UI using Selenium.
- Applies filters for:
  - Sector (e.g., Healthcare, Agricultural)
  - Index (e.g., Nifty 50, Nifty 100)
  - Market Cap range
  - Close Price range
- Handles dynamic pagination and clicks through pages automatically.
- Extracts detailed stock data:
  - Company Name
  - Market Price
  - Close Price
  - Market Capitalization (Cr)
- Stores data in a structured CSV format.
- Works in headless mode (no browser window opens).

## Technologies Used

- Ruby
- Selenium WebDriver
- Nokogiri
- CSV Library
- ChromeDriver