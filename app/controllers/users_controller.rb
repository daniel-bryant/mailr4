class UsersController < ApplicationController
  before_action :signed_in_user, only: [:edit, :update]
  before_action :correct_user,   only: [:edit, :update]

  def show
    @user = User.find(params[:id])
    mail_setup
    #@emails = Mail.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to your new secure mailbox!"
      redirect_to mail_path
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
      params.require(:user).permit(:name, :first, :last, :birthday,
                                   :gender, :phone, :email, :country,
                                   :password, :password_confirmation)
    end

    # Before filters

    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in." unless signed_in?
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def mail_setup
      Mail.defaults do
        retriever_method :pop3, :address    => "pop.gmail.com",
                                :port       => 995,
                                :user_name  => 'bryant.daniel.j@gmail.com',
                                :password   => 'fibonacci',
                                :enable_ssl => true
      end
    end
end
