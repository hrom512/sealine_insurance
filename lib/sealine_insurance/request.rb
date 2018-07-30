# frozen_string_literal: true

module SealineInsurance
  class Request
    attr_reader :config

    def initialize(config:)
      @config = config
    end

    def get(url)
      send_request(:get, url)
    end

    def post(url, data)
      send_request(:post, url, data)
    end

    private

    def send_request(method, url, body = nil)
      conn = Faraday.new do |builder|
        builder.adapter Faraday.default_adapter
        builder.response(:logger, config.logger) if config.logger
      end
      conn.send(method, "#{config.base_url}#{url}.json") do |req|
        req.headers['Authorization'] = "Token #{config.token}"
        if body
          req.headers['Content-Type'] = 'application/json'
          req.body = body.to_json
          config.logger&.debug(req.body)
        end
        req.options.timeout = config.timeout if config.timeout
        req.options.open_timeout = config.open_timeout if config.open_timeout
      end
    rescue Faraday::Error => e
      raise RequestError, "#{e.class}: #{e.message}"
    end
  end
end
