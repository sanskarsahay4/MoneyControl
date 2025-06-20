require 'selenium-webdriver'
require 'nokogiri'
require 'csv'

class MarketCaps
    def self.marketCap_value(lower, higher, driver)
        market_cap_table = driver.find_element(xpath: '//*[@id="root"]/div[2]/div[1]/div/div[1]/div/div[4]/div/div')

        lower_limit = market_cap_table.find_element(xpath: './/input[@id="rf36LowInput"]')
        lower_limit.clear
        lower_limit.send_keys([:control, 'a'], lower)

        higher_limit = market_cap_table.find_element(xpath: './/input[@id="rf36HighInput"]')
        higher_limit.clear
        higher_limit.send_keys([:control, 'a'], higher)
    end

    def self.marketCap_button(range,driver)
        begin
            market_cap_button_table = driver.find_element(xpath: '//*[@id="root"]/div[2]/div[1]/div/div[1]/div/div[4]/div/div/div[2]/div/div/div/div[3]')
            options = market_cap_button_table.find_element(xpath: ".//input[contains(text(), '#{range}')]")
            options.click
        rescue => e
            return
        end
    end

    def self.marketCap_drag(lower, higher, driver)
        market_cap_drag_lower = driver.find_element(xpath: '//*[@id="root"]/div[2]/div[1]/div/div[1]/div/div[4]/div/div/div[2]/div/div/div/div[1]/div[1]')
        drivers = driver.action
        drivers.click_and_hold(market_cap_drag_lower).move_by("#{lower * 42}",0).release.perform
        
        market_cap_drag_higher = driver.find_element(xpath: '//*[@id="root"]/div[2]/div[1]/div/div[1]/div/div[4]/div/div/div[2]/div/div/div/div[1]/div[3]')
        drivers = driver.action
        drivers.click_and_hold(market_cap_drag_higher).move_by("#{(8 - higher) * -42}",0).release.perform
    end
end

class ClosePrice
    def self.closePrice_value(lower, higher, driver)
        close_price_table = driver.find_element(xpath: '//*[@id="root"]/div[2]/div[1]/div/div[1]/div/div[5]/div/div')

        lower_limit = close_price_table.find_element(xpath: './/input[@id="rf36LowInput"]')
        lower_limit.clear
        lower_limit.send_keys([:control, 'a'], lower)

        higher_limit = close_price_table.find_element(xpath: './/input[@id="rf36HighInput"]')
        higher_limit.clear
        higher_limit.send_keys([:control, 'a'], higher)
    end

    def self.closePrice_drag(lower, higher, driver)
        close_price_drag_lower = driver.find_element(xpath: '//*[@id="root"]/div[2]/div[1]/div/div[1]/div/div[5]/div/div/div[2]/div/div/div/div[1]/div[1]')
        drivers = driver.action
        drivers.click_and_hold(close_price_drag_lower).move_by("#{lower * 42}",0).release.perform
        sleep 10

        close_price_drag_higher = driver.find_element(xpath: '//*[@id="root"]/div[2]/div[1]/div/div[1]/div/div[5]/div/div/div[2]/div/div/div/div[1]/div[3]')
        drivers = driver.action
        drivers.click_and_hold(close_price_drag_higher).move_by("#{(7 - higher) * -42}",0).release.perform
        sleep 10
    end
end

def seleniumInit(url)
    # options = Selenium::WebDriver::Chrome::Options.new
    # options.add_argument("--headless")

    driver = Selenium::WebDriver.for :chrome#, options: options
    driver.get(url)
    driver
end

def data_table(doc, store_data)
    div_table = doc.css("#root > div:nth-child(2) > div.container.web-align > div > div.ssp76ScreenerMain.width100.layout-main > div:nth-child(2) > table")
    rows = div_table.css("> tbody > tr")
    rows.each do |divs|
        company = divs.at("> td.bodyBaseHeavy > a > span").text.strip
        market_price = divs.at("> td:nth-child(3) > div > div.st76CurrVal.bodyBaseHeavy").text.strip
        close_price = divs.at("> td:nth-child(4)").text.strip
        market_caps = divs.at("> td:nth-child(5)").text.strip

        store_data << {
            "Company" => company,
            "Market Price" => market_price,
            "Close Price" => close_price,
            "Market Caps(Cr)" => market_caps
        }
    end
end

def pageParse(driver)
    store_data = []
    page = 1
    loop do
        doc = Nokogiri::HTML(driver.page_source)

        data_table(doc, store_data)

        begin
            page += 1
            next_button = driver.find_element(xpath: "//*[@id=\"root\"]/div[2]/div[1]/div/div[2]/div[2]/div/div[2]/div[contains(text(), '#{page}')]")
            next_button.click
            sleep 2
        rescue => e
            break
        end
    end
    store_data
end

def csvCreate(file_name, store_data)
    CSV.open(file_name,"w") do |csv|
        headers = store_data.first.keys
        csv << headers
        store_data.each do |row|
            csv << headers.map { |head| row[head] || "" }
        end
    end
end

def sectors(names, driver)
    sectors_table = driver.find_element(xpath: '//*[@id="root"]/div[2]/div[1]/div/div[1]/div/div[2]/div/div[2]/div/div/div/div[2]')

    names.each do |name|
        options = sectors_table.find_element(xpath: ".//div/div/div[contains(text(), '#{name}')]")
        options.click
    end
end

def index(names, driver)
    index_table = driver.find_element(xpath: '//*[@id="root"]/div[2]/div[1]/div/div[1]/div/div[3]/div/div')
    names.each do |name|
        options = index_table.find_element(xpath: ".//div/div/div/div/div[contains(text(), '#{name}')]")
        options.click
    end
end

def addFilters(driver)
    sectors(["Healthcare", "Agricultural"], driver)

    index(["Nifty 50", "Nifty 100"], driver)

    # MarketCaps.marketCap_value("1000", "500000", driver)
    # MarketCaps.marketCap_button("Small", driver)
    MarketCaps.marketCap_drag(2, 7, driver)

    # ClosePrice.closePrice_value("1000", "500000", driver)
    ClosePrice.closePrice_drag(3, 8, driver)
end

def main()
    url = "https://groww.in/stocks/filter"
    driver = seleniumInit(url)

    addFilters(driver)
    sleep 20

    store_data = pageParse(driver)
    csvCreate("groww_output.csv",store_data)
end

main()
