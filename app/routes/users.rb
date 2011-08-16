# encoding: utf-8
class Wowbom < Sinatra::Base
  get "/login" do
    erb :login
  end
  
  get "/register" do
    @page[:class] = "register"
    @fields       = User.registration_fields
    
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
      new_user.save
      redirect session[:requested_path]
    else
      # show registration form again with errors
      @page[:class] = "register"
      @fields       = new_user.registration_fields
      @errors       = new_user.errors.to_hash
      erb :register
    end
  end
  
  post "/available/email" do
    User.all(:email => params[:email]).any? ? "false" : "true"
  end
  
  post "/available/login" do
    User.all(:login => params[:login]).any? ? "false" : "true"
  end
  
  get "/me" do
    # session["foo"] = "bar"
    # session[:requested_path] = request.path
    # redirect "/register?requested_path=#{request.path}"
  end
end