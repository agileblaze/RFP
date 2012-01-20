class UserMailer < ActionMailer::Base
   require 'date'
  def signup_notification(user)
    setup_email(user)
    @subject    += 'Please activate your new account'
    @body[:url]  = "http://#{configatron.site_url}/activate/#{user.activation_code}"
  end
  
  def reset_password(user)
    setup_email(user)
    @subject += "Your password has been reset"
    @body[:url]  = "http://#{configatron.site_url}/login"
  end
  
  def forgot_password(user)
    setup_email(user)
    @subject += "Forgotten password instructions"
    @body[:url]  = "http://#{configatron.site_url}/users/reset_password/#{user.password_reset_code}"
  end
  
  def forgot_login(user)
    setup_email(user)
    @subject += "Forgotten account login"
    @body[:url]  = "http://#{configatron.site_url}/login"
  end
  
  def activation(user)
    setup_email(user)
    @subject    += 'Your account has been activated!'
    @body[:url]  = "http://#{configatron.site_url}/"
  end

  def assign_rfp(user,user1,project,rfp)
     setup_email(user)
     @subject    += 'RFP Is Assigned To You'
     @user1=user1
     @project=project
     @user=user
     @rfp=rfp
     @body[:url]  = "http://#{configatron.site_url}/login"
     content_type  "text/html"
     
     #content_type  "multipart/mixed"

#     part :content_type => "text/html", :body => "Hello,
         #     This Is Information From Site - #{configatron.site_name} <br />
         #     <br /><br />
         #     RFP of a project #{@rfp.project_name } is assigned to you By  #{@user1.login}  , its deadline -#{@rfp.deadline}   <br /><br /><br />
         #     Best regards,
          #    <br />
              #{configatron.site_name} Team.#"
     #attachment :filename => "#{rfp.filename}",:content_type => "text/html", :body => File.read("/home/users/shamith/railsproject/RFP/RFP_tool/public#{rfp.public_filename}")
  end


  def reassign_rfp(userto,userby,project)
     setup_email(userto)
     @subject    += 'RFP Is Assigned To You'
     @userby=userby
     @project=project
     @userto=userto
     #@rfp=rfp
     @body[:url]  = "http://#{configatron.site_url}/login"
     content_type  "text/html"
  end

  def add_rfp(userto,userby,project,rfp)
     setup_email(userto)
     @subject    += "new RFP of project #{project.project_name.capitalize} Is Assigned To You"
     @userby=userby
     @project=project
     @userto=userto
     @rfp=rfp
     @body[:url]  = "http://#{configatron.site_url}/login"
     content_type  "text/html"
  end

 def self.dailymail
    #@user=User.find_by_sql("select * from rfps LEFT OUTER JOIN rfp_documents ON rfps.id=rfp_documents.rfp_id JOIN users ON users.id=rfps.assigned_to WHERE rfps.deadline > DATE( now( ))")
    # @user.each do |u|
     #setup_email(u)
     # u=User.find(24)
   #    UserMailer.deliver_daily_send(u)
   #   UserMailer.deliver_daily_send(user)

   @user=User.find_by_sql("select * from users join rfps on rfps.assigned_to=users.id where rfps.rfp_doc_uploaded='no' and rfps.deadline >=CURDATE()")
    @user.each do |user|
      @rfp=user
      UserMailer.deliver_daily_send(user)
    end
 end

def daily_send(user)
   setup_email(user)
   #@rfp=rfp
   @user=user
   content_type  "text/html"
    @subject="RFP tool Reminder"
    @data=user
   #setup_email(user)
end

protected
    def setup_email(user)
      @recipients  = "#{user.email}"
      @from        = "#{configatron.support_name} <#{configatron.support_email}>"
      @subject     = "[#{configatron.site_name}] "
      @sent_on     = Time.now
      @body[:user] = user
      #@attachments['filename.pdf'] = File.read("/home/users/shamith/railsproject/RFP/RFP_tool/public#{rfp.public_filename}")
      #@content_type = "text/html"
      #@attachments['filename'] = File.read(rfp.public_filename)
      #Get Settings
      [:site_name, :company_name, :support_email, :support_name].each do |id|
        @body[id] = configatron.send(id)
      end
    end
end