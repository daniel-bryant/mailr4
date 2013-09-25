class EmailsController < ApplicationController
  before_action :signed_in_user

  def create
    @new_email = current_user.emails.build(email_params)
    @err = true

    if params[:commit] == 'send'
      @new_email.box = 2
      ship_mail(@new_email)
      if @new_email.save
        flash[:success] = "Mail Sent"
        redirect_to :back
        @err = false
      end
    elsif params[:commit] == 'save'
      @new_email.box = 3
      if @new_email.save
        flash[:success] = "Saved to Drafts"
        redirect_to :back
        @err = false
      end
    else
      if @new_email.save
        flash[:success] = "New Mail"
        redirect_to :back
        @err = false
      end
    end

    if @err
      flash[:error] = "Error Saving or Retrieving"
      redirect_to :back
    end
  end

  def destroy
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

end
