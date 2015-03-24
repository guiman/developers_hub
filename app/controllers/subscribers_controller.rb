class SubscribersController < ApplicationController
  def new
    @user = Subscriber.new
  end

  def create
    @user = Subscriber.new(subscriber_params)

    if @user.save
      flash[:notice] = "You have successfully subscribed! We will keep you posted!"
      redirect_to root_path
    else
      render :new
    end
  end

  def subscriber_params
    params.require(:subscriber).permit(:email)
  end
end
