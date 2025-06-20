require 'selenium-webdriver'
require 'nokogiri'
require 'csv'
require 'set'

def seleniumInit(url)
    driver = Selenium::WebDriver.for :chrome
    driver.get(url)

    driver
end


def innerDivs(div_table, processed_keys, store_data)
    inner_divs = div_table.css("> div")

    inner_divs.each do |divs|
        date = divs.css("div:nth-child(1) > div > p > span").text.strip
        comp_name = divs.css("div.InfoCardsSec_web_comAndPrize__BSppv > div > h3 > a").text.strip
        research_by = divs.css("div:nth-child(3) > a > p").text.strip.delete_prefix("Research by")

        key = "#{date}_#{comp_name}_#{research_by}"
        next if processed_keys.include?(key)
        processed_keys << key

        reco_price = divs.css("div.InfoCardsSec_web_dnTAble__XQgQl > ul > li:nth-child(1) > p > span").text.strip
        target = divs.css("div.InfoCardsSec_web_dnTAble__XQgQl > ul > li:nth-child(2) > span").text.strip
        
        store_data << {
            "Date" => date,
            "Company Name" => comp_name,
            "Research by" => research_by,
            "Reco Price" => reco_price,
            "Target" => target
        }
    end

    store_data
end

def pageParse(driver, max_time)
    start_time = Time.now

    store_data = []
    processed_keys = Set.new

    while Time.now - start_time < max_time
        doc = Nokogiri::HTML(driver.page_source)

        div_table = doc.css("#__next > main > div.container_web_mcContainer__P8Xe9 > div > div.container_web_LftBar__0l3Ur > section > div")
        if div_table.nil?
            driver.navigate.refresh
            next
        end

        innerDivs(div_table, processed_keys, store_data)

        target_element = driver.find_element(css: "#__next > div:nth-child(11) > footer > div.footer_container")
        driver.execute_script("arguments[0].scrollIntoView();",target_element)
        sleep 3
    end

    return store_data
end

def csvCreate(file_name, store_data)
    CSV.open(file_name, "w") do |csv|
        headers = store_data.first.keys
        csv << headers

        store_data.each do |row|
            csv << headers.map { |head| row[head] || "" }
        end
    end
end

def main
    url = "https://www.moneycontrol.com/markets/stock-ideas/"
    driver = seleniumInit(url)

    max_time = 120
    store_data = pageParse(driver, max_time)
    driver.quit

    csvCreate("money_control.csv", store_data)
end

main()
