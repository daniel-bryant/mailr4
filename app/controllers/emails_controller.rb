class EmailsController < ApplicationController
  before_action :signed_in_email, only: [:edit, :update]
  before_action :correct_email,  only: [:edit, :update]

  def create
    @email = current_user.emails.build(email_params)
    @err = true

    if params[:commit] == 'send'
      @email.box = 2
      #ship_mail(@email)
      if @email.save
        flash[:success] = "Mail Sent"
        redirect_to :back
        @err = false
      end
    elsif params[:commit] == 'save'
      @email.box = 3
      if @email.save
        flash[:success] = "Saved to Drafts"
        redirect_to :back
        @err = false
      end
    else
      if @email.save
        flash[:success] = "New Mail"
        redirect_to :back
        @err = false
      end
    end

    if @err
      flash[:error] = "Error"
      redirect_to :back
    end
  end

  def edit
    @user = current_user
  end

  def update
    @err = true

    if params[:commit] == 'send'
      @email.box = 2
      #ship_mail(@email)
      if @email.update_attributes(email_params)
        flash[:success] = "Mail Sent"
        redirect_to current_user
        @err = false
      end
    elsif params[:commit] == 'save'
      @email.box = 3
      if @email.update_attributes(email_params)
        flash[:success] = "Draft Updated"
        redirect_to current_user
        @err = false
      end
    else
      
    end

    if @err
      render 'edit'
    end
  end

  def destroy
    @email.destroy
    redirect_to current_user
  end

  private

    def email_params
      params.require(:email).permit(:box, :star, :from, :to, :subject, :body, :date)
    end

    def ship_mail(outgoing)
      Mail.deliver do
        from    outgoing.from
        to      outgoing.to
        subject outgoing.subject
        body    outgoing.body
      end
    end

    # Before filters

    def signed_in_email
      redirect_to signin_url, notice: "Please sign in." unless signed_in?
    end

    def correct_email
      redirect_to(root_url) unless @email = current_user.emails.find(params[:id])
    end

end
