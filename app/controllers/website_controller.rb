class WebsiteController < ApplicationController
  include PaymentHelper

  def index
    @token = nil
  end

  def donate
    charity = find_charity
    omise_token = params[:omise_token]
    amount = params[:amount].try(:to_f).try(:round, Charity::PRECISION_LIMIT)

    if omise_token
      @token = retrieve_token omise_token

      if valid_amount?(amount) && charity
        charge = make_payment amount, omise_token, charity

        if charge.paid
          charity.credit_amount(charge.amount)
          render_success
          return
        else
          @token = nil
        end
      end
    else
      @token = nil
    end

    render_error
  end

  private

  def valid_amount? amount
    amount && amount > Charity::MINIMUM_TOTAL_AMOUNT
  end

  def render_error
    flash.now.alert = t(".failure")
    render :index
  end

  def render_success
    flash.notice = t(".success")
    if params[:charity] == "random"
      render :index
    else
      redirect_to root_path
    end

  end

  def find_charity
    if params[:charity] == "random"
      Charity.offset(rand(Charity.count)).first
    else
      Charity.find_by id: params[:charity]
    end
  end
end
