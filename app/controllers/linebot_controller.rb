class LinebotController < ApplicationController

	require 'line/bot'

		# @@saved_post = nil

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

						if /.*\d+日.+？/ === event.message['text'] || /明日.+？/ === event.message['text'] || /明後日.+？/ === event.message['text']


							day = event.message['text'].sub(/\d+月/, "").delete("^0-9")

							month = event.message['text'].sub(/\d+日/, "").delete("^0-9")

							if /明日.+？/ === event.message['text']

							day = Date.today.next_day(1).day
							month = Date.today.next_day(1).month

							elsif /明後日.+？/ === event.message['text']

								day = Date.today.next_day(2).day
							month = Date.today.next_day(2).month

							end

							if /明日.+？/ === event.message['text'] || /明後日.+？/ === event.message['text'] || !day.empty?

								if /明日.+？/ === event.message['text'] || /明後日.+？/ === event.message['text'] || !month.empty?

									if month.to_i >= Date.today.month.to_i

										year = Date.today.year
										@post = Post.find_by("start_time <= ? and end_time >= ?", "#{year}-#{format("%02d", month)}-#{format("%02d", day)}", "#{year}-#{format("%02d", month)}-#{format("%02d", day)}")

									else

										year = Date.today.next_year(1).year
										@post = Post.find_by("start_time <= ? and end_time >= ?", "#{year}-#{format("%02d", month)}-#{format("%02d", day)}", "#{year}-#{format("%02d", month)}-#{format("%02d", day)}")

									end

								else

									if day.to_i > Date.today.day.to_i

										year = Date.today.year
										month = Date.today.month
										@post = Post.find_by("start_time <= ? and end_time >= ?", "#{year}-#{format("%02d", month)}-#{format("%02d", day)}", "#{year}-#{format("%02d", month)}-#{format("%02d", day)}")
							
									else

										year = Date.today.next_month(1).year
										month = Date.today.next_month(1).month
										@post = Post.find_by("start_time <= ? and end_time >= ?", "#{year}-#{format("%02d", month)}-#{format("%02d", day)}", "#{year}-#{format("%02d", month)}-#{format("%02d", day)}")
									end

								end

								if @post == nil
									message = {
										type: 'text',
										text: "#{month}月#{day}日の晩ごはん情報は未定です🙏\n予定の更新をお待ちください。"
									}
								elsif @post.comment == "ｲﾝﾀｰﾝ"
									message = {
										type: 'text',
										text: "#{month}月#{day}日はインターンのため東京にいます。"
									}
								else

									case @post.content
									when "◯"
										message = {
											type: 'text',
											text: "#{month}月#{day}日は家で食べます。\n#{@post.comment}の予定なので遅くなります🙏"
										}
									when "❌"
										message = {
											type: 'text',
											text: "#{month}月#{day}日は#{@post.comment}の予定なので、晩ごはんはいらないです。"
										}
									when "🔺"
										message = {
											type: 'text',
											text: "#{month}月#{day}日は晩ごはんどうなるかわからないです😥\n当日の連絡をお待ちください。"
										}
									when "未定"
										message = {
											type: 'text',
											text: "#{month}月#{day}日の晩ごはん情報は未定です🙏\n予定の更新をお待ちください。"
										}
									when ""
										message = {
											type: 'text',
											text: "#{month}月#{day}日は家で食べます。\n夜7時ごろには家にいると思います。"
										}
									end
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

				# if Post.find_by(start_time: Date.today).present?

				# 	@post = Post.find_by(start_time: Date.today)
				# 	@@saved_post = @post

				# elsif Post.find_by(start_time: Date.today).blank? && (@@saved_post == nil || @@saved_post.end_time < Date.today)

				# 	@@saved_post = nil
				# 	@post = @@saved_post
				
				# elsif Post.find_by(start_time: Date.today).blank? && @@saved_post.end_time >= Date.today

				# 	@post = @@saved_post

				# end

				@post = Post.find_by("start_time <= ? and end_time >= ?", Date.today, Date.today)

				if @post.comment == "ｲﾝﾀｰﾝ"

				elsif @post.comment == ""
					
					message = {
						type: 'text',
						text: "今日は晩ごはんを家で食べます。\n夜19時ごろには家にいると思います。\n変更があれば連絡します。\nいつも美味しいご飯ありがとうございます"
					}
						
				elsif @post != nil?
				
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
					end

				else
						message = {
							type: 'text',
							text: "今日の晩ごはん情報ですが、予定を更新し忘れているので、浩太郎に直接聞いてください🙏"
						}
				end
		
        client = Line::Bot::Client.new { |config|
            config.channel_secret = "da5be14c010d092c6a188bf9fb79f071"
            config.channel_token = "l6MsxS40JGaFsZlSSR3br5fZ1i6Ofks3hELPEne65kqzM695FyfjS1fgVUMWB93Vt/XCa0mY9nZTdOJ7/eqYoQnFCzEEBDrV7kiILjIqqf7+1Nqj7vpxnmZO6vUgwYWhU4RzTt6hH49bykuVByprcwdB04t89/1O/w1cDnyilFU="
        }
        response = client.push_message("Ccbf94e2e1eac61156ffd7be4aee3f1bd", message)
        p response
		end
		
  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = "da5be14c010d092c6a188bf9fb79f071"
      config.channel_token = "l6MsxS40JGaFsZlSSR3br5fZ1i6Ofks3hELPEne65kqzM695FyfjS1fgVUMWB93Vt/XCa0mY9nZTdOJ7/eqYoQnFCzEEBDrV7kiILjIqqf7+1Nqj7vpxnmZO6vUgwYWhU4RzTt6hH49bykuVByprcwdB04t89/1O/w1cDnyilFU="
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