class Link < ApplicationRecord
  belongs_to :page

  validates :url, presence: true, format: URI::regexp(%w[http https])
end
