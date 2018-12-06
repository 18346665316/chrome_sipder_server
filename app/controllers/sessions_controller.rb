require 'base64'


class SessionsController < ApplicationController

  skip_before_action :verify_authenticity_token

  def new
  end

  def create
    user = User.find_by(name: params[:session][:name])
    if user && user.password ==  params[:session][:password]
      log_in user
      num = rand(0xffffff).to_s
      base_str = Base64.encode64(user.password + user.name + num)
      cookies[:id] = base_str
      cookies[:name] = user.name
      cookies[:admin] = user.admin
      user.token = base_str
      user.save
      render json: {code:'true'}
    else
      render json: {code:'false'}
    end
  end

  def token
    user = User.find_by(name: cookies[:name])
    cookies_token  = cookies[:id]
      if user&&user.token == cookies_token
        render json: {code: 'true'}
      else
        render json: {code:'false'}
      end
    end

  def destroy
    user = User.find_by(name: cookies[:name])
    if user
      user.token = ''
      user.save
      render json: {code:'true'}
    else
      render json: {code:'true'}
    end

  end

end

