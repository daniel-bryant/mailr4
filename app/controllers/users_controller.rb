require 'will_paginate/array'

class UsersController < ApplicationController
  before_action :signed_in_user, only: [:edit, :update]
  before_action :correct_user,   only: [:edit, :update]

  def show
    @user = User.find(params[:id])
    retrieve_mail

    #sets of emails
    @in_arr = Array.new
    @star_arr = Array.new
    @out_arr = Array.new
    @draft_arr = Array.new
    @trash_arr = Array.new

    @user.emails.each do |m|
      @in_arr.push(m) if m.box == 1
      @star_arr.push(m) if m.star == true
      @out_arr.push(m) if m.box == 2
      @draft_arr.push(m) if m.box == 3    
      @trash_arr.push(m) if m.box == 4
    end

    @in_mails = @in_arr.paginate(page: params[:in_page])
    @star_mails = @star_arr.paginate(page: params[:star_page])
    @out_mails = @out_arr.paginate(page: params[:out_page])
    @draft_mails = @draft_arr.paginate(page: params[:draft_page])
    @trash_mails = @trash_arr.paginate(page: params[:trash_page])

    #single email
    @new_mail = @user.emails.build if signed_in?
    @reply_mail = @user.emails.build if signed_in?
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to your new secure mailbox!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :first, :last, :email,
                                   :password, :password_confirmation)
    end

    # Before filters

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def retrieve_mail
      Mail.defaults do
        retriever_method :pop3, :address    => "pop.gmail.com",
                                :port       => 995,
                                :user_name  => 'bryant.daniel.j@gmail.com',
                                :password   => 'fibonacci',
                                :enable_ssl => true
      end

      Mail.all.each do | mail |
        @some_mail = current_user.emails.build box: 1,
                                               star: false,
                                               from: mail.from.first,
                                               to: mail.to.first,
                                               subject: mail.subject,
                                               body: mail.body.decoded,
                                               date: mail.date.to_s,
                                               is_new: true
        @some_mail.save
      end
      #@some_mail = current_user.emails.build box: 1, from: "dan@test.com", to: "dan@test.com", subject: "hello", body: "this is the body"
      #@some_mail.save
    end
end
