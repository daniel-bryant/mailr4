class EmailsController < ApplicationController
  before_action :signed_in_email, only: [:edit, :update]
  before_action :correct_email,  only: [:edit, :update]

  def show
    @email = current_user.emails.find(params[:id])
    @email.update_attributes(is_new: false)
    @new_mail = current_user.emails.build if signed_in?
    @reply_mail = current_user.emails.build if signed_in?
  end

  def create
    @email = current_user.emails.build(email_params)
    @err = true

    if params[:commit] == 'send'
      @email.box = 3
      #ship_mail(@email)
      if @email.save
        @email.update_attributes(box: 2)
        flash[:success] = "Mail Sent"
        redirect_to current_user
        @err = false
      end
    elsif params[:commit] == 'save'
      @email.box = 3
      if @email.save
        flash[:success] = "Saved to Drafts"
        redirect_to current_user
        @err = false
      end
    else
      # do nothing
    end

    if @err
      render 'edit'
    end
  end

  def edit
    @new_mail = current_user.emails.build if signed_in?
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
      #do nothing
    end

    if @err
      render 'edit'
    end
  end

  def destroy
    @email.destroy
    redirect_to current_user
  end

  def deletemany
    @to_delete = current_user.emails.find(dm_params)
    @to_delete.each do |t|
      if t.box == 4
        t.destroy
      else
        t.box = 4
        t.save
      end
    end 
    redirect_to current_user
  end

  private

    def email_params
      params.require(:email).permit(:box, :star, :from, :to, :subject, :body, :date, :is_new)
    end

    def dm_params
      params.require(:emails)
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
