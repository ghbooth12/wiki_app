class ChargesController < ApplicationController
  def create
    # Creates a Stripe Customer object, for associating
    # with the charge
    customer = Stripe::Customer.create(
      email: current_user.email,
      card:  params[:stripeToken]
    )

    # Where the real magic happens
    charge = Stripe::Charge.create(
      customer:    customer.id, # Note -- this is NOW the user_id in your app
      amount:      Amount.default,
      description: "BigMoney Membership - #{current_user.email}",
      currency:    'usd'
    )

    current_user.premium!
    flash[:notice] = "Upgraded to Premium successfully, #{current_user.email}! Feel free to create the private wikis!"
    redirect_to wikis_path
  end

  # Stripe will send back CardErrors, with friendly messages
  # When something goes wrong.
  # This 'rescue block' catches and displays those errors.
  # rescue Stripe::CardError => e
  #   flash.now[:alert] = e.message
  #   redirect_to new_charge_path
  # end

  def new
    @stripe_btn_data = {
      key:         "#{ Rails.configuration.stripe[:publishable_key] }",
      description: "BigMoney Membership - #{current_user.email}",
      amount:      Amount.default
    }
  end

  def cancel_premium
    current_user.standard!
    flash[:notice] = "You have canceled Premium servie, #{current_user.email}! You are now #{current_user.role} member."
    redirect_to wikis_path
  end
end
