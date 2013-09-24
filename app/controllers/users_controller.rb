class UsersController < ApplicationController
  before_action :signed_in_user, only: [:edit, :update]
  before_action :correct_user,   only: [:edit, :update]

  def show
    @user = User.find(params[:id])
    #retrieve_mail

    #sets of emails
    @in_mail = @user.emails.take_while{ |mail| mail.box == 1 }
    @star_mail = @user.emails.take_while{ |mail| mail.star == true }
    @out_mail = @user.emails.take_while{ |mail| mail.box == 2 }
    @draft_mail = current_user.emails.take_while{ |mail| mail.box == 3 }
    
    #single email
    @new_mail = current_user.emails.build(from: "#{@user.name}@#{CONFIG['domain']}") if signed_in?
    #@new_mail = Email.new(from: "#{@user.name}@#{CONFIG['domain']}")
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
                                :password   => '',
                                :enable_ssl => true
      end

      Mail.all.each do | mail |
        @user.emails.create box: 1,
                            star: false,
                            from: mail.from,
                            to: mail.to,
                            subject: mail.subject,
                            body: mail.body.decoded,
                            date: mail.date.to_s
      end
    end
end
