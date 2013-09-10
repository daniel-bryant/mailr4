module ApplicationHelper
  # Returns the proper form to be rendered according to title
  def header_btn(page_title)
    if page_title=='signin'
      render 'layouts/signin_page_btn'
    elsif page_title=='signup'
      render 'layouts/signup_page_btn'
    elsif page_title=='mail'
      render 'layouts/mail_page_btn'
    else

    end
  end
end
