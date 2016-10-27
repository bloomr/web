module Admin
  class EmailCampaign < ActiveRecord::Base
    attr_accessor :logs

    after_initialize :initialize_log
    before_save :serialize_log

    def self.table_name_prefix
      'admin_'
    end

    def process_campaign
      users = build_recipients
      users.each_with_index do |user, i|
        options = build_options(user)
        begin
          Mailchimp.send_template(options)
          log_success(user)
        rescue StandardError => e
          log_error(user, e.message)
        ensure
          save if i % 10 == 0
        end
      end
      self.finished = true
      save
    end

    def build_recipients
      result = []
      result = User.where(published: true).order(:id) if published_bloomeurs

      unless recipients.blank?
        emails = recipients.split(',').map(&:strip)
        result += User.where(email: emails)
      end

      result
    end

    def build_options(user)
      {
        template_name: template_name,
        to_mail: user.email,
        from_mail: 'stephanie@bloomr.org',
        from_name: 'Stephanie de Bloomr',
        vars: build_vars(user)
      }
    end

    def build_vars(user)
      vars = {}
      (1..3).each do |i|
        name = send("var#{i}_name")
        value = send("var#{i}_value")
        vars[name.to_sym] = user.send(value) unless name.blank? || value.blank?
      end
      vars
    end

    def log_success(user)
      logs['success'].push('id' => user.id)
    end

    def log_error(user, message)
      logs['errors'].push('id' => user.id, 'message' => message)
    end

    def initialize_log
      self.logs = if logs_text.nil?
                    { 'errors' => [], 'success' => [] }
                  else
                    JSON.parse(logs_text)
                  end
    end

    def serialize_log
      self.logs_text = logs.to_json.to_s
    end
  end
end
