class Email < ActiveRecord::Base
	state_machine :initial => :pending do
		event :process do
			transition :pending => :processing
		end
		after_transition on: :process, do: :start_processing

		event :resolve do
			transition :processing => :resolved
		end

		event :reject do
			transition :processing => :rejected
		end
		after_transition on: :reject, do: :notify_sender_of_rejection
	end

	serialize :error_messages

	attr_accessible :action, :attachment_count, :body_html, :body_plain, :content_id_map, :from, :message_headers, :recipient, :sender, :signature, :stripped_html, :stripped_signature, :stripped_text, :subject, :timestamp, :token

	def self.process email_id
		email = Email.find(email_id)
		email.process
	end

private

	def start_processing
		if self.send("process_#{self.action}")
			self.resolve
		else
			self.reject
		end
	end

	def process_message
		attrs = self.recipient.split("@")[0].split("_")

		self.error_messages << "Message sent to unknown email address." unless m_id = attrs[-2].try(:to_i) and m_auth_token = attrs[-1]
		self.error_messages << "Could not find the message you are trying to reply to." unless m_id and message = Message.find(m_id)
		if message
			self.error_messages << "Authorization token is invalid." unless message.authentication_token == m_auth_token
			# TODO: This does not work when you forward your email to another address. Think about alternatives.
			# self.error_messages << "your email address is not authorized to reply to this message" unless message.to.email == sender
			self.error_messages << "This message has already been replied to." unless message.conversation.last_message_id == message.id
			self.error_messages << "Reply is too long, it contained #{self.stripped_text.size} characters but #{message.max_char_count} characters is the max. Because most email clients have no character counter we give you a lot of leeway, but #{self.stripped_text.size - message.max_char_count} characters over is more than double. Please pair it down a bit and reply again to the original email." if self.stripped_text.size > (message.max_char_count * 2)
		end

		if self.error_messages.any?
			self.rejection_message = "Sorry, your reply could not be saved. When you try again, make sure to reply directly to the original message."
			new_message = false
		else
			new_message = message.email_reply(self.stripped_text, m_auth_token)
		end

		self.save

		new_message
	end

	def notify_sender_of_rejection
		NotificationsMailer.delay_for(2.seconds).email_rejected(self.id)
	end

end
