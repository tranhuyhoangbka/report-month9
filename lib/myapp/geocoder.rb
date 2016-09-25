class Myapp::Geocoder
  TYPES = {
    country: "country",
    area: "administrative_area_level_1",
    address_1_part_1: %w(locality political),
    address_1_part_2: "sublocality_level_1"
  }

  def initialize search_term, language
    @search_term = search_term
    @language = language
    @address_info = search_address
  end

  def full_address_info_hash
    {
      country: get_location,
      area: get_area,
      address: get_first_address
    }
  end

  private
  attr_reader :search_term, :language, :address_info

  def search_address
    address = Geocoder.search search_term, params: {language: language}
    return {} unless address.present?
    address.first.data["address_components"]
  end

  def choose_address_item_by type
    address_info.find do |entry|
      type.is_a?(Array) ? entry["types"] == type : type.in?(entry["types"])
    end.try(:[], "long_name").to_s
  end

  def get_location
    choose_address_item_by TYPES[:country]
  end

  def get_area
    choose_address_item_by TYPES[:area]
  end

  def get_first_address
    separate_char = language == :ja ? "" : " "
    [choose_address_item_by(TYPES[:address_1_part_1]),
      choose_address_item_by(TYPES[:address_1_part_2])].join separate_char
  end
end
