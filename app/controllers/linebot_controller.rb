class LinebotController < ApplicationController

	require 'line/bot'

		@@saved_post = nil

		# callbackアクションのCSRFトークン認証を無効
		protect_from_forgery :except => [:callback]

		def callback
			body = request.body.read
			signature = request.env['HTTP_X_LINE_SIGNATURE']
			unless client.validate_signature(body, signature)
				error 400 do 'Bad Request' end
			end
			events = client.parse_events_from(body)
	
			events.each do |event|
				case event
				when Line::Bot::Event::Message
					case event.type
					when Line::Bot::Event::MessageType::Text
						day = event.message['text'].sub(/\d+月/, "").delete("^0-9")
						if day != nil

							if day.to_i > Date.today.day.to_i

								@post = Post.find_by("start_time <= ? and end_time >= ?", "2019-09-#{day}", "2019-09-#{day}")
					
							end

							if @post == nil
								message = {
									type: 'text',
									text: day + "日は家で食べます。\n夜7時ごろには家にいると思います。"
								}
							elsif @post.comment == "ｲﾝﾀｰﾝ"
								message = {
									type: 'text',
									text: day + "日はインターンのため東京にいます。"
								}
							else

								case @post.content
								when "◯"
									message = {
										type: 'text',
										text: day + "日は家で食べます。\n#{@post.comment}の予定なので遅くなります🙏"
									}
								when "❌"
									message = {
										type: 'text',
										text: day + "日は#{@post.comment}の予定なので、晩ごはんはいらないです。"
									}
								when "🔺"
									message = {
										type: 'text',
										text: day + "日は晩ごはんどうなるかわからないです😥\n当日の連絡をお待ちください。"
									}
								when "未定"
									message = {
										type: 'text',
										text: day + "日の晩ごはん情報は未定です🙏\n当予定の更新をお待ちください。"
									}
								when ""
									message = {
										type: 'text',
										text: day + "日は家で食べます。\n夜7時ごろには家にいると思います。"
									}
								end
							end
						end
					end
				end
				client.reply_message(event['replyToken'], message)
			end
			head :ok
		end

		def push

				if Post.find_by(start_time: Date.today).present?

					@post = Post.find_by(start_time: Date.today)
					@@saved_post = @post

				elsif Post.find_by(start_time: Date.today).blank? && (@@saved_post == nil || @@saved_post.end_time < Date.today)

					@@saved_post = nil
					@post = @@saved_post
				
				elsif Post.find_by(start_time: Date.today).blank? && @@saved_post.end_time >= Date.today

					@post = @@saved_post

				end

				if @post == nil
					message = {
						type: 'text',
						text: "今日の晩ごはん情報ですが、予定を更新し忘れているので、浩太郎に直接聞いてください🙏"
					}
				elsif @post.comment == "ｲﾝﾀｰﾝ"
						
				else
				
					case @post.content
					when "◯"
						message = {
							type: 'text',
							text: "今日は晩ごはん家で食べます。\n#{@post.comment}の予定なので遅くなります🙏\nいつも美味しいご飯ありがとうございます"
						}
					when "❌"
						message = {
							type: 'text',
							text: "今日は#{@post.comment}の予定なので、晩ごはんはいらないです。"
						}
					when "🔺"
						message = {
							type: 'text',
							text: "今日は晩ごはんどうなるかわからないです😥\n分かり次第、連絡します。\nもし、しばらく連絡がなければ浩太郎に確認してください。"
						}
					when "未定"
						message = {
							type: 'text',
							text: "今日の晩ごはん情報ですが、予定を更新し忘れているので、浩太郎に直接聞いてください🙏"
						}
					when ""
						message = {
							type: 'text',
							text: "今日は晩ごはんを家で食べます。\n夜19時ごろには家にいると思います。\n変更があれば連絡します。\nいつも美味しいご飯ありがとうございます"
						}
					end

				end
		
        client = Line::Bot::Client.new { |config|
            config.channel_secret = "68205f7a1e3339f3c020d80148a820e9"
            config.channel_token = "RwgTi9ap0+o3zeMJNITgJ4nDbNyLZNM+t4fi2OWIpC5B7/MDJyAE3kVZA7dtKpGjPuasUU7cYvTWPivXJDxZPFdymU5isWEXVL7mFROsgUG8scfCCvBoybZwp3GRVuOqidqUr9ltcxgQnavqikFFngdB04t89/1O/w1cDnyilFU="
        }
        response = client.push_message("Ubb563e765d94830aa20f3a1a251de66c", message)
        p response
		end
		
  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = "68205f7a1e3339f3c020d80148a820e9"
      config.channel_token = "RwgTi9ap0+o3zeMJNITgJ4nDbNyLZNM+t4fi2OWIpC5B7/MDJyAE3kVZA7dtKpGjPuasUU7cYvTWPivXJDxZPFdymU5isWEXVL7mFROsgUG8scfCCvBoybZwp3GRVuOqidqUr9ltcxgQnavqikFFngdB04t89/1O/w1cDnyilFU="
    }
  end


	# recieveアクションのCSRFトークン認証を無効
  # protect_from_forgery :except => [:recieve]

	# ユーザIDやグループID取得用
  # def recieve
  #   body = request.body.read

  #   signature = request.env['HTTP_X_LINE_SIGNATURE']
  #   unless client.validate_signature(body, signature)
  #     head :bad_request
  #   end

  #   events = client.parse_events_from(body)

  #   events.each { |event|
	# 		groupId = event['source']['groupId']  #groupId取得
	# 		p 'groupID: ' + groupId # groupIdを確
  #   }

  #   head :ok
	# end

end