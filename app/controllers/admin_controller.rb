class AdminController < ApplicationController
  def index
    @shelters = Shelter.reverse_alphabetical
    @shelters_with_pending_apps = Shelter.shelters_with_pending_applications
  end

  def show_pending_applications
    render 'applications/index', locals: {
      applications: Application.order(status: :desc).where.not(status: 'In Progress')
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

  def approve_pet
    @pet = Pet.find(params[:id])
    @application = Application.find(params[:application_id])
    @pet.update_status_for_application(@application.id, 'approved')
    review_application
  end

  def reject_pet
    @pet = Pet.find(params[:id])
    @application = Application.find(params[:application_id])
    @pet.update_status_for_application(@application.id, 'rejected')

    review_application
  end

  def destroy
    @application = Application.find(params[:id])
    @application.destroy
    flash[:notice] = "Application was successfully destroyed."
    redirect_to '/admin/applications', locals: {
      applications: @applications
    }
  end

  private

  def review_application
    status = @application.review_status

    if @application.save
      flash[:notice] = 'Review Processed'
      redirect_to "/admin/applications/#{@application.id}"
    else
      flash[:alert] = "Something went wrong"
      redirect_to "/admin/applications/#{@application.id}"
    end
  end

end
