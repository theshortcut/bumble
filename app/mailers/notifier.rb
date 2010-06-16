class Notifier < ActionMailer::Base
  def password_reset_instructions(user)
    @edit_password_reset_url = edit_password_reset_url(user.perishable_token)
    mail(:to => user.email,
         :subject => 'Password Reset Instructions')
  end

  def activation_instructions(user)
    @account_activation_url = activate_url(user.perishable_token)
    mail(:to => user.email,
         :subject => 'Activation Instructions')
  end

  def activation_confirmation(user)
    @root_url = root_url
    mail(:to => user.email,
         :subject => 'Welcome to Bumble')
  end

  def new_comment_alert(comment)
    @comment = comment
    mail(:to => comment.post.user.email,
         :subject => "New Comment on #{comment.post.title}")
  end
end
