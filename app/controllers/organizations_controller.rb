class OrganizationsController < ApplicationController
  def show
    @organization = Organization.find_by_login(params[:login])
  end
end
