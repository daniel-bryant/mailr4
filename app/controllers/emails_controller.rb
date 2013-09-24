class EmailsController < ApplicationController
  before_action :signed_in_user

  def create
    @new_email = current_user.emails.build(email_params)
    
    if params[:commit] == 'send'
      @new_email.box = 2
      ship_mail(@new_email)
      flash[:success] = "Mail Sent"
    elsif params[:commit] == 'save'
      @new_email.box = 3
      flash[:success] = "Saved to Drafts"
    end

    if @new_email.save
      redirect_to :back
    else
      flash[:error] = "Draft not saved"
      redirect_to :back
    end
  end

  def destroy
  end

  private

    def email_params
      params.require(:email).permit(:from, :to, :subject, :body)
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
