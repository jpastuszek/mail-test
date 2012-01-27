Given /test e-mail from ([^ ]*) to ([^ ]*)/ do |from, to|
	@email_from = from
	@email_to = to
	@email_uuid = uuid	
	@email_body = <<EOF
From: #{@email_from}
To: #{@email_to}
Subject: Test e-mail #{@email_uuid}

Test #{@email_uuid}
EOF
end

When /I send it to ([^ ]*)$/ do |server|
	begin
		Net::SMTP.start(server) do |smtp|
			smtp.send_message(@email_body, @email_from, @email_to)
		end
		@smtp_error = nil
	rescue Net::ProtoFatalError => e
		@smtp_error = e
	end
end

When /I send it to ([^ ]*) authenticated with ([^ ]*) ([^ ]*):([^ ]*) over TLS connection/ do |server, auth, login, password|
	begin
		smtp = Net::SMTP.new(server)
		smtp.enable_starttls

		smtp.start('localhost', login, password, auth) do |smtp|
			smtp.send_message(@email_body, @email_from, @email_to)
		end
		@smtp_error = nil
	rescue Net::ProtoFatalError => e
		@smtp_error = e
	end
end

Then /I should get no SMTP error/ do
	@smtp_error.should be_nil
end

Then /I should get SMTP error: (.*)/ do |msg|
	@smtp_error.message.should include(msg)
end

Then /I should find it in ([^ ]*) IMAP (.*) authenticated with ([^ ]*) ([^ ]*):([^ ]*) over TLS connection within (\d+) seconds/ do |server, mailbox, auth, login, password, timeout|
	Timeout.timeout(timeout.to_i) {
		imap = Net::IMAP.new(server, 'imaps', true)
		imap.authenticate(auth, login, password)
		imap.select(mailbox)
		emails = nil
		loop do
			emails = imap.search(["SUBJECT", "Test e-mail #{@email_uuid}"])
			break unless emails.empty?
			sleep 0.5
		end

		emails.should have(1).email

		emails.each do |message_id|
			imap.fetch(message_id, 'RFC822')[0].attr['RFC822'].split("\r\n").last.should == "Test #{@email_uuid}"

			imap.store(message_id, "+FLAGS", [:Deleted])
		end

		imap.close
		imap.disconnect
	}
end
