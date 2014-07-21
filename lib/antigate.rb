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

  	def recognize(captcha_file, ext)
  		added = nil
  		loop do
  			added = add(captcha_file, ext)
        next if added.nil?
  			if added.include? 'ERROR_NO_SLOT_AVAILABLE'
  				sleep(1)
  				next
  			else
  				break
  			end
  		end
  		if added.include? 'OK'
  			id = added.split('|')[1]
  			sleep(10)
  			status = nil
  			loop do
  				status = status(id)
          next if status.nil?
  				if status.include? 'CAPCHA_NOT_READY'
  					sleep(1)
  					next
  				else
  					break
  				end
  			end
  			return [id, status.split('|')[1]]
  		else
  			return added
  		end
  	end

  	def add(captcha_file, ext)
      if captcha_file.include?("http")
    	  uri = URI.parse(url)
    	  http = Net::HTTP.new(uri.host, uri.port)
    	  http.use_ssl = (uri.port == 443)
    	  request = Net::HTTP::Get.new(uri.request_uri)
    	  response = http.request(request)
    	  captcha = response.body
      else
        captcha = File.read("#{captcha_file}.#{ext}")
      end
  		if captcha
  			params = {
  				'method' => 'base64',
  				'key' => @key,
  				'body' => Base64.encode64(captcha),
  				'ext' => ext,
  				'phrase' => @phrase,
  				'regsense' => @regsense,
  				'numeric' => @numeric,
  				'calc' => @calc,
  				'min_len' => @min_len,
  				'max_len' => @max_len
  			}
  			return Net::HTTP.post_form(URI("http://#{@domain}/in.php"), params).body rescue nil
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
