class LinebotController < ApplicationController
	require 'line/bot'
		# @@groupId = 0
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
            config.channel_secret = "da5be14c010d092c6a188bf9fb79f071"
            config.channel_token = "l6MsxS40JGaFsZlSSR3br5fZ1i6Ofks3hELPEne65kqzM695FyfjS1fgVUMWB93Vt/XCa0mY9nZTdOJ7/eqYoQnFCzEEBDrV7kiILjIqqf7+1Nqj7vpxnmZO6vUgwYWhU4RzTt6hH49bykuVByprcwdB04t89/1O/w1cDnyilFU="
        }
        response = client.push_message(userId, message)
        p response
		end
		
		# def recieve
		# 	body = request.body.read

		# 	events = client.parse_events_from(body)
		# 	events.each { |event|
		# 		@@groupId = event['source']['groupId']  #userId取得
		# 		# p 'UserID: ' + userId # UserIdを確認
		# 	end
		# 	head :ok
		# end

		def client
			@client ||= Line::Bot::Client.new { |config|
				config.channel_secret = "da5be14c010d092c6a188bf9fb79f071"
				config.channel_token = "l6MsxS40JGaFsZlSSR3br5fZ1i6Ofks3hELPEne65kqzM695FyfjS1fgVUMWB93Vt/XCa0mY9nZTdOJ7/eqYoQnFCzEEBDrV7kiILjIqqf7+1Nqj7vpxnmZO6vUgwYWhU4RzTt6hH49bykuVByprcwdB04t89/1O/w1cDnyilFU="
			}
		end
		def recieve
			body = request.body.read
			events = client.parse_events_from(body)
			events.each { |event|
				userId = event['source']['userId']  #userId取得
				p 'UserID: ' + userId # UserIdを確認
			end

end
