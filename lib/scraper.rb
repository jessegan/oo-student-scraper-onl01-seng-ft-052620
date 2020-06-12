require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    index = Nokogiri::HTML(open(index_url))
    index.css("div.student-card").map do |student_data|
      {
        name: student_data.css("h4.student-name").text,
        location: student_data.css("p.student-location").text,
        profile_url: student_data.css("a").attribute("href").text
      }
    end
  end

  def self.scrape_profile_page(profile_url)
    profile = Nokogiri::HTML(open(profile_url))
    profile_hash = {}
    #socials
    socials = profile.css("div.social-icon-container a").map do |social_data|
      social_data.attribute("href").text
    end

    socials.each do |link|
      if link.include?("twitter.com")
        profile_hash[:twitter] = link
      elsif link.include?("linkedin.com")
        profile_hash[:linkedin] = link
      elsif link.include?("github.com")
        profile_hash[:github] = link
      else
        profile_hash[:blog] = link
      end
    end
    #quote
    profile_hash[:profile_quote] = profile.css("div.profile-quote").text.strip
    #bio
    profile_hash[:bio] = profile.css("div.description-holder p").text.strip
    #return
    profile_hash
  end

end