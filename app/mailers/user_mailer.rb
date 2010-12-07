class UserMailer < ActionMailer::Base
  default :from => "#{Grundlebox::Config::SiteTitle} <#{Grundlebox::Config::SiteEmail}>"
  
  def welcome_email(user)
    @user = user
    mail(:to => user.email, :subject => "Welcome to #{Grundlebox::Config::SiteTitle}")
  end
  
  def reset_password(user, new_password)
    @user = user
    @password = new_password
    mail(:to => user.email, :subject => "#{Grundlebox::Config::SiteTitle} password reset")
  end
  
end