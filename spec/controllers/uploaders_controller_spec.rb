require 'rails_helper'

describe UploadersController, type: :controller do
  let(:user) { create(:user) }

  #Test case for index action
  describe 'GET #index' do
    it "populates an array of uploaders" do
      sign_in user
      uploader = FactoryGirl.create(:uploader)
      get :index
      expect(assigns(:uploaders)).to eq([uploader])
    end

    it "renders the :index view" do
      sign_in user
      get :index
      expect(response).to render_template("index")
    end
  end

  #Test case for show action
  describe "GET #show" do
    it "assigns the requested uploader to @uploader" do
      sign_in user
      uploader = FactoryGirl.create(:uploader)
      get :show, id: uploader
      expect(assigns(:uploader)).to eq(Uploader.last)
    end

    it "renders the #show view" do
      sign_in user
      get :show, id: FactoryGirl.create(:uploader)
      expect(response).to render_template("show")
    end
  end

  #Test case for new action
  describe "GET #new" do
    it "creates new uploader" do
      sign_in user
      get :new
      expect(assigns(:uploader).name).to eq(nil)
    end

    it "renders the #new view" do
      sign_in user
      get :new
      expect(response).to render_template("new")
    end
  end

  #Test case for create action
  describe "POST #create" do
    it "creates a new uploader" do
      sign_in user
      expect{ post :create, uploader: { path: fixture_file_upload('test.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet') } }.to change(Uploader, :count).by(1)
    end

    it "redirects to the new uploader" do
      sign_in user
      post :create, uploader: { path: fixture_file_upload('test.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet') }
      expect(response).to redirect_to Uploader.last
    end

    it "does not save the new uploader" do
      sign_in user
      post :create, uploader: { path: fixture_file_upload('invalid.jpg', 'jpeg') }
      expect{ response }.to_not change(Uploader, :count)
    end

    it "re-renders the new method" do
      sign_in user
      post :create, uploader: { patith: fixture_file_upload('invalid.jpg', 'jpeg') }
      expect(response).to render_template(nil)
    end

    describe "#upload" do
      it "should upload file and run parser" do
        sign_in user
        post :create, uploader: {path: fixture_file_upload('test.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')}

        expect(user.uploaders.count).to be(1)
        uploader = user.uploaders.last
        expect(uploader.completed?).to be_truthy
        expect(uploader.total_row).to be(5)
        expect(uploader.current_row).to be(5)
      end

      it "should not run parser if invalid file type" do
      end
    end
  end

  describe "DELETE destroy" do
    before :each do
      @uploader = FactoryGirl.create(:uploader)
    end

    it "deletes the uploader" do
      sign_in user
      expect{
        delete :destroy, id: @uploader
      }.to change(Uploader, :count).by(-1)
    end
  end
end