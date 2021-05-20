 require 'rails_helper'

RSpec.describe "/applications", type: :request do

  let(:valid_attributes) {
    attributes_for(:application)
  }

  let(:invalid_attributes) {
    {description: nil, status: nil}
  }

  describe "GET /index" do
    it "renders a successful response" do
      Application.create! valid_attributes
      get applications_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      application = Application.create! valid_attributes
      get application_url(application)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_application_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "render a successful response" do
      application = Application.create! valid_attributes
      get edit_application_url(application)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Application" do
        expect {
          post applications_url, params: { application: valid_attributes }
        }.to change(Application, :count).by(1)
      end

      it "redirects to the created application" do
        post applications_url, params: { application: valid_attributes }
        expect(response).to redirect_to(application_url(Application.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Application" do
        expect {
          post applications_url, params: { application: invalid_attributes }
        }.to change(Application, :count).by(0)
      end

      xit "renders a successful response (i.e. to display the 'new' template)" do
        post applications_url, params: { application: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        attributes_for(:application)
      }

      it "updates the requested application" do
        application = Application.create! valid_attributes
        patch application_url(application), params: { application: new_attributes }
        application.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the application" do
        application = Application.create! valid_attributes
        patch application_url(application), params: { application: new_attributes }
        application.reload
        expect(response).to redirect_to(application_url(application))
      end
    end

    context "with invalid parameters" do
      xit "renders a successful response (i.e. to display the 'edit' template)" do
        application = Application.create! valid_attributes
        patch application_url(application), params: { application: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested application" do
      application = Application.create! valid_attributes
      expect {
        delete application_url(application)
      }.to change(Application, :count).by(-1)
    end

    it "redirects to the applications list" do
      application = Application.create! valid_attributes
      delete application_url(application)
      expect(response).to redirect_to(applications_url)
    end
  end
end
