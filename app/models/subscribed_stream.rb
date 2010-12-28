class SubscribedStream < ActiveRecord::Base
  belongs_to :stream
  belongs_to :user

  def self.subscribed?(stream_id, user_id)
    self.count(:conditions => { :user_id => user_id, :stream_id => stream_id }) > 0
  end

  def self.all_subscribers(stream_id)
    emails = Array.new
    self.all(:conditions => ["stream_id = ?", stream_id]).each do |s|
      next if s.user.blank? or s.user.email.blank?
      emails << s.user.email
    end

    return emails
  end

  def self.job_active?
    last_check = Stream.maximum('last_subscription_check')
    return false if last_check.blank?
    
    last_check > 15.minutes.ago
  end

end