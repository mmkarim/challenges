module PaymentHelper
  def retrieve_token token
    if Rails.env.test?
      OpenStruct.new({
        id: "tokn_X",
        card: OpenStruct.new({
          name: "J DOE",
          last_digits: "4242",
          expiration_month: 10,
          expiration_year: 2020,
          security_code_check: false,
        }),
      })
    else
      Omise::Token.retrieve token
    end
  end

  def make_payment amount, omise_token, charity
    if Rails.env.test?
      OpenStruct.new({
        amount: (amount * 100).round,
        paid: (amount != 999),
      })
    else
      Omise::Charge.create({
        amount: (amount * 100).round,
        currency: "THB",
        card: omise_token,
        description: "Donation to #{charity.name} [#{charity.id}]",
      })
    end
  end
end
