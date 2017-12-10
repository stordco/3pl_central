module ThreePLCentral
  class Item < Base
    attr_accessor :item_data

    def initialize(params)
      if params[:facility_id]
        facility_id = params[:facility_id]
        params.delete(:facility_id)
      end
      @item_data = params
    end


    def create
      xml_hash = create_creds
      xml_hash["items"] = [{item:item_data}]
      ThreePLCentral::Services.create_items(xml_hash)
    end

    class << self

      def find(params)
        xml_hash = read_creds
        xml_hash["limitCount"] = 10
        xml_hash["focr"] = params
        response = ThreePLCentral::Services.find_items(xml_hash)
        parser.parse(response.body[:find_items])["items"]["item"].arrayify
      end

      def create(params)
        o = Item.new(params)
        o.create
      end

    end
  end
end
