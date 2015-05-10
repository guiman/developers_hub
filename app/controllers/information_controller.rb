class InformationController < ApplicationController
  def welcome
    @user = Subscriber.new
  end

  def about
  end
end
