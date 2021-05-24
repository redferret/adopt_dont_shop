class AdminSheltersController < ApplicationController
  def index
    @shelters = Shelter.reverse_alphabetical

    @shelters_with_pending_apps = Shelter.get_shelters_with_pending_applications
  end
end
