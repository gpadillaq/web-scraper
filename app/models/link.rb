require "ipaddr"
require "resolv"

class Link < ApplicationRecord
  belongs_to :page

  validates :url, presence: true
  validate :url_must_be_safe

  private


  def url_must_be_safe
    uri = URI.parse(url)

    unless uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
      errors.add(:url, "must use HTTP or HTTPS")
      return
    end

    # Prevent SSRF: resolve IP and block private ones
    begin
      addr = Resolv.getaddress(uri.host)
      ip = IPAddr.new(addr)

      if ip.private? || ip.loopback? || ip.link_local? || ip == "127.0.0.1"
        errors.add(:url, "points to a disallowed IP")
      end
    rescue Resolv::ResolvError
      errors.add(:url, "could not be resolved")
    end

  rescue URI::InvalidURIError
    errors.add(:url, "is invalid")
  end
end
