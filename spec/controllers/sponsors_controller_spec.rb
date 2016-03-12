require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe SponsorsController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Sponsor. As you add validations to Sponsor, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    {name: 'Google', weblink: 'http://google.ie', weight: 100, contact_email: 'bloke@gmail.com', contact_name: 'Some Bloke', valid_until: 1.year.from_now, notes: 'Just a test'}
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # SponsorsController. Be sure to keep this updated too.
  let(:user) { create(:user, roles: 'treasurer') }
  let(:valid_session) { {} }

  describe "GET #index" do
    it "assigns all sponsors as @sponsors" do
      sponsor = Sponsor.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:sponsors).matches).to eq([sponsor])
    end
  end
end
