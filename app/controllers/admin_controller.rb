class AdminController < ApplicationController
  def index
    @shelters = Shelter.reverse_alphabetical
    @shelters_with_pending_apps = Shelter.shelters_with_pending_applications
  end

  def show
    @shelter = Shelter.find(params[:id])
  end

  def show_pending_applications
    render 'applications/index', locals: {
      applications: Application.where(status: 'Pending')
    }
  end

  def show_shelter_applications
    render 'applications/index', locals: {
      applications: Application.all_for_shelter(params[:shelter_id]),
    }
  end

  def show_application
    @application = Application.find(params[:id])
    render 'applications/show', locals: {
      application: @application,
      pets_found: [],
      back_path: '/admin/applications',
      admin_view: true
    }
  end

end
