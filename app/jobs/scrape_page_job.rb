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

      new_link = page.links.build(url: href, name: link.text.strip.presence || "No Name")
      unless new_link.save
        Rails.logger.warn "Invalid link for page #{page.id}: #{new_link.errors.full_messages.join(', ')}"
      end
    end

    page.status = "completed"
    page.save!
  rescue StandardError => e
    page.update(status: "failed")
    Rails.logger.error "Failed scraping page #{page.id}: #{e.message}"
  end
end
