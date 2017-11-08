require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    html = File.read(index_url)
    students = Nokogiri::HTML(html)

    students.css("div.student-card").collect do |student|
      student_hash = {}
      student_hash[:name] = student.css("h4.student-name").text
      student_hash[:location] = student.css("p.student-location").text
      student_hash[:profile_url] = student.css("a").attribute("href").value
      student_hash
    end
  end

  def self.scrape_profile_page(profile_url)

    html = open(profile_url)
    profile = Nokogiri::HTML(html)

    hash = {:profile_quote=>profile.css("div.profile-quote").text,
            :bio=> profile.css("div.description-holder p").text #try div.bio-content
           }

    profile.css("div.social-icon-container a").each do |account|
      if account.css("img").attribute("src").value == "../assets/img/twitter-icon.png"
        hash[:twitter] = account.attribute("href").value
      elsif account.css("img").attribute("src").value == "../assets/img/linkedin-icon.png"
        hash[:linkedin] = account.attribute("href").value
      elsif account.css("img").attribute("src").value == "../assets/img/github-icon.png"
        hash[:github] = account.attribute("href").value
      elsif account.css("img").attribute("src").value == "../assets/img/rss-icon.png"
        hash[:blog] = account.attribute("href").value
      end
    end
    hash
  end

end
