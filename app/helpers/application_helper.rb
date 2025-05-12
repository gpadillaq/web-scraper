module ApplicationHelper
  def safe_url(url)
    uri = URI.parse(url)
    if uri.is_a?(URI::HTTP) && uri.host.present?
      sanitized_url = "#{uri.scheme}://#{uri.host}"
      sanitized_url += ":#{uri.port}" if uri.port && ![ 80, 443 ].include?(uri.port)
      sanitized_url += uri.path if uri.path
      sanitized_url += "?#{uri.query}" if uri.query
      sanitized_url += "##{uri.fragment}" if uri.fragment
      h(sanitized_url)
    end
  rescue URI::InvalidURIError
    nil
  end
end
