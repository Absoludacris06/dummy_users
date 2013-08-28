enable :sessions

get '/' do
  @errors = [] 
  erb :index
end

post '/signup' do
  @new_user = User.create(params[:post])
  if @new_user.valid?
    session[:user_email] = @new_user.email
    session[:user_name] = @new_user.name
    erb :secret
  else
    @errors = @new_user.errors.full_messages
    erb :index
  end
end

post '/login' do
  if user = User.authenticate(params[:email], params[:password])
    session[:user_email] = user.email
    session[:user_name] = user.name
    erb :secret
  else
    erb :login_error
  end
end

post '/logout' do 
  session[:user_email] = nil
  session[:user_name] = nil
  redirect to('/')
end

before '/secret_page' do
  if session[:user_email] == nil
    redirect to('/')
  end
end

get '/secret_page' do 
  erb :secret
end
