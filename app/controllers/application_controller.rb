class ApplicationController < ActionController::Base
	# require 'line/bot'

  # protect_from_forgery with: :null_session

  # before_action :validate_signature

  # def validate_signature
  #   body = request.body.read
  #   signature = request.env['HTTP_X_LINE_SIGNATURE']
  #   unless client.validate_signature(body, signature)
  #     error 400 do 'Bad Request' end
  #   end
  # end

  # def client
  #   @client ||= Line::Bot::Client.new { |config|
  #     config.channel_secret = ENV['LINE_CHANNEL_SECRET']
  #     config.channel_token = ENV['LINE_CHANNEL_TOKEN']
  #   }
	# end
	
	protect_from_forgery with: :exception
  before_action :is_validate_signature

  CHANNEL_SECRET = ENV['CHANNEL_SECRET']

  # verify access from LINE
  private
  def is_validate_signature
    signature = request.headers["X-LINE-Signature"]
    signature_answer = signature_answer_builder

    render :nothing => true, status: 470 unless signature == signature_answer
  end

  private
  def signature_answer_builder
    http_request_body = request.raw_post
    hash = OpenSSL::HMAC::digest(OpenSSL::Digest::SHA256.new, CHANNEL_SECRET, http_request_body)
    Base64.strict_encode64(hash)
	end
	
end
