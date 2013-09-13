class EmailsController < ApplicationController
  before_action :signed_in_user

  def create
    @new_email = current_user.emails.build(email_params)
    if @new_email.save
      flash[:success] = "Saved to Drafts"
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

end
