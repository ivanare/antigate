require "antigate/version"

module Antigate
  require 'net/http'
  require 'uri'
  require 'base64'

  def self.wrapper(key)
    return Wrapper.new(key)
  end

  def self.balance(key)
    wrapper = Wrapper.new(key)
    return wrapper.balance
  end

  class Wrapper
    attr_accessor :phrase, :regsense, :numeric, :calc, :min_len, :max_len, :domain

    def initialize(key)
      @key = key

      @phrase = 0
      @regsense = 0
      @numeric = 0
      @calc = 0
      @min_len = 0
      @max_len = 0
      @domain = "antigate.com"
    end

    def recognize(url, ext)
      id = add(url, ext)
      sleep(10)
      return result(id)
    end

    def recognize_image(image, ext)
      id = upload(image, ext)
      sleep(10)
      return result(id)
    end

    def add(url, ext)
      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = (uri.port == 443)
      request = Net::HTTP::Get.new(uri.request_uri)
      response = http.request(request)
      captcha = response.body
      return upload(captcha, ext) if captcha
    end

    def upload(image, ext)
      loop do
        params = {
          'method' => 'base64',
          'key' => @key,
          'body' => Base64.encode64(image),
          'ext' => ext,
          'phrase' => @phrase,
          'regsense' => @regsense,
          'numeric' => @numeric,
          'calc' => @calc,
          'min_len' => @min_len,
          'max_len' => @max_len
        }
        response = Net::HTTP.post_form(URI("http://#{@domain}/in.php"), params).body rescue nil

        if response.nil?
          next
        elsif response.include? 'ERROR_NO_SLOT_AVAILABLE'
          sleep(1)
        elsif response.include? 'OK'
          return response.split('|')[1]
        else
          raise response
        end
      end
    end

    def result(id)
      loop do
        status = status(id)
        if status.nil?
          next
        elsif status.include? 'CAPCHA_NOT_READY'
          sleep(1)
        else
          return [id, status.split('|')[1]]
        end
      end
    end

    def status(id)
      return Net::HTTP.get(URI("http://#{@domain}/res.php?key=#{@key}&action=get&id=#{id}")) rescue nil
    end

    def bad(id)
      return Net::HTTP.get(URI("http://#{@domain}/res.php?key=#{@key}&action=reportbad&id=#{id}")) rescue nil
    end

    def balance
      return Net::HTTP.get(URI("http://#{@domain}/res.php?key=#{@key}&action=getbalance")) rescue nil
    end
  end
end
