require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
  	data = Nokogiri::HTML(open(index_url))

    results = []

    data.css('.student-card').each do |card|
    	person = {}
    	person[:name] = card.css('h4').text
    	person[:location] = card.css('p').text
    	person[:profile_url] = './fixtures/student-site/' + 
    		card.css('a').attribute('href').text
    	results << person
    end

    results
  end

  def self.scrape_profile_page(profile_url)
    data = Nokogiri::HTML(open(profile_url))

    person = {}

    links = data.css('div.social-icon-container a').collect do |item|
    	item.attribute('href').text
    end

    person[:twitter] = links.detect { |link| link.include?('twitter') }
    person[:linkedin] = links.detect { |link| link.include?('linkedin') }
    person[:github] = links.detect { |link| link.include?('github') }
    person[:blog] = links[-1] unless links[-1].include?('github')
    person[:profile_quote] = data.css('.vitals-text-container div').text
    person[:bio] = data.css('.description-holder p').text
    person.delete_if { |k, v| v.nil? }

    person
  end

end