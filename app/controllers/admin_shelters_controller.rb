class AdminSheltersController < ApplicationController
  def index
    @shelters = Shelter.reverse_alphabetical

    @shelters_with_pending_apps = Shelter.joins(pets: :applications).where("applications.status = 'Pending'").group(:id)
  end
end
