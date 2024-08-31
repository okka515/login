require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require './models'
require 'sinatra/activerecord'

enable :sessions

get '/' do
    if session
        erb :index
    else
        redirect '/signin'
    end
end

get '/signup' do
    erb :sign_up
end

post '/signup' do
    user = Users.create(name: params[:name], mail: params[:mail], password_digest: params[:password_digest])
    if user.persisted?
        session[:user] = user.id
        redirect '/'
    else
        redirect '/signup'
    end
end

get '/signin' do
    erb :sign_in
end

post '/signin' do
    user = Users.find_by(mail: params[:mail])
    if user && user.authenticate(params[:password_digest])
        session[:user] = user.id
        redirect '/'
    else
        redirect '/signin'
    end
end