class ScrapePageJob < ApplicationJob
  queue_as :default

  def perform(page_id)
    page = Page.find(page_id)
    response = HTTParty.get(page.url)
    doc = Nokogiri::HTML(response.body)

    page.title = doc.title.presence || page.url

    doc.css("a").each do |link|
      href = link["href"]
      next unless href.present? && href.match?(URI.regexp(%w[http https]))

      page.links.create(url: href, name: link.text.strip.presence || "No Name")
    end

    page.status = "completed"
    page.save!
  rescue StandardError => e
    page.update(status: "failed")
    Rails.logger.error "Failed scraping page #{page.id}: #{e.message}"
  end
end
