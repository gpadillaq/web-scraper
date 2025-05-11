class Page < ApplicationRecord
  has_many :links, dependent: :destroy

  validates :url, presence: true, format: URI.regexp(%w[http https])
end
