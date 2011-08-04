# encoding: utf-8
class Wowbom < Sinatra::Base
  get "/login" do
    erb :login
  end
  
  get "/register" do
    @fields = User.registration_fields
    erb :register
  end
  
  post "/register" do
    new_user = User.new(
      :login                 => params[:login], 
      :displayname           => params[:displayname], 
      :email                 => params[:email],
      :password              => params[:password],
      :password_confirmation => params[:password_confirmation]
    )
    if new_user.valid?
      # save and redirect to origin
    else
      # show registration form again with errors
      @fields = new_user.registration_fields
      erb :register
    end
  end
  
  get "/me" do
    @foo = "bar!"
    redirect '/register'
  end
end