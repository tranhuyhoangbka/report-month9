class AddressesController < ApplicationController
  def index
    render json: Myapp::Geocoder.new(params[:postal_code], "en").full_address_info_hash
  end
end
