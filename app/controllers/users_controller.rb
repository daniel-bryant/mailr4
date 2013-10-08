require 'will_paginate/array'

class UsersController < ApplicationController
  before_action :signed_in_user, only: [:edit, :update]
  before_action :correct_user,   only: [:edit, :update]

  def show
    @user = User.find(params[:id])
    retrieve_mail
    @box_arr = @user.emails.where(box: 1).by_age
    @box_mails = @box_arr.paginate(page: params[:box_page])
    @new_mail = @user.emails.build if signed_in?
  end

  def inbox
    setup_mailbox(box: 1)
  end

  def starred
    setup_mailbox(star: true)
  end

  def sent
    setup_mailbox(box: 2)
  end

  def drafts
    setup_mailbox(box: 3)
  end

  def trash
    setup_mailbox(box: 4)
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
    @new_mail = @user.emails.build if signed_in?
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

    def setup_mailbox(condition)
      @user = User.find(params[:id])
      retrieve_mail
      @box_arr = @user.emails.where(condition).by_age
      @box_mails = @box_arr.paginate(page: params[:box_page])
      @new_mail = @user.emails.build if signed_in?
      render 'show'
    end

    def retrieve_mail
      Mail.defaults do
        retriever_method :pop3, :address    => "#{ CONFIG['pop-server'] }",
                                :port       => 995,
                                :user_name  => 'bryant.daniel.j@gmail.com',
                                :password   => '',
                                :enable_ssl => true
      end

      #Mail.all.each do | mail |
      #  @some_mail = current_user.emails.build box: 1,
      #                                         star: false,
      #                                         from: mail.from.first,
      #                                         to: mail.to.first,
      #                                         subject: mail.subject,
      #                                         body: mail.body.decoded,
      #                                         date: mail.date.to_s,
      #                                         is_new: true
      #  @some_mail.save
      #end
      #@some_mail = @user.emails.build box: 1, from: "dan@test.com", to: "daniel@example.com", subject: "hello", body: "this is the body", is_new: true
      #@some_mail.save
    end
end
