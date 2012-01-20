class Notifier < ActionMailer::Base
  

  def hello_world(sent_at = Time.now)
    subject    'Notifier#hello_world'
    recipients ''
    from       ''
    sent_on    sent_at
    
    body       :greeting => 'Hi,'
  end

end
