module TrackerApi
  module Resources
    class TimeZone
      include Virtus.value_object

      values do
        attribute :offset, String
        attribute :olson_name, String
        attribute :kind, String
      end
    end
  end
end
