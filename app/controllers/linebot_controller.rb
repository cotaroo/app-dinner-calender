class LinebotController < ApplicationController

	require 'line/bot'

		def push

				@post = Post.find_by(start_time: Date.today)

				if @post == nil
					message = {
						type: 'text',
						text: "今日は晩ごはんを家で食べます。\n夜19時ごろには家にいると思います。\n変更があれば連絡します。\nいつも美味しいご飯ありがとうございます"
					}
				else
				
					case @post.content
					when "◯"
						message = {
							type: 'text',
							text: "今日は晩ごはんを家で食べます。\n#{@post.comment}の予定なので遅くなるかも🙏\nいつも美味しいご飯ありがとうございます"
						}
					when "❌"
						message = {
							type: 'text',
							text: "今日は#{@post.comment}の予定なので、晩ごはんはいらないです。"
						}
					when "🔺"
						message = {
							type: 'text',
							text: "今日は晩ごはんどうなるかわからないです😥\n分かり次第、連絡します。\nもし、しばらく連絡がなければ連絡してくれるとありがたいです。"
						}
					when "未定"
						message = {
							type: 'text',
							text: "今日の晩ごはん情報ですが、浩太郎が予定を更新し忘れているので、浩太郎に直接聞いてもらえると助かります🙏"
						}
					end

				end
		
        client = Line::Bot::Client.new { |config|
            config.channel_secret = "1574242480"
            config.channel_token = "da5be14c010d092c6a188bf9fb79f071"
        }
        response = client.push_message(Ubb563e765d94830aa20f3a1a251de66c, message)
        p response
		end
		
		# def recieve
		# 	body = request.body.read
		
		# 	signature = request.env['HTTP_X_LINE_SIGNATURE']
		# 	unless client.validate_signature(body, signature)
		# 		error 400 do 'Bad Request' end
		# 	end
		
		# 	events = client.parse_events_from(body)
		# 	events.each do |event|
		# 		userId = event['source']['userId']  #userId取得
		# 		p 'UserID: ' + userId # UserIdを確認
		# 	end
		# end

		require 'line/bot'  # gem 'line-bot-api'

  # callbackアクションのCSRFトークン認証を無効
  protect_from_forgery :except => [:callback]

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end

  def callback
    body = request.body.read

    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      head :bad_request
    end

    events = client.parse_events_from(body)

    events.each { |event|
      case event
      when Line::Bot::Event::Message
        # case event.type
        # when Line::Bot::Event::MessageType::Text
        #   message = {
        #     type: 'text',
        #     text: event.message['text']
        #   }
        #   client.reply_message(event['replyToken'], message)
        # end
      end
    }

    head :ok
  end

end
