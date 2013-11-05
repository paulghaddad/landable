module Landable
  module Traffic
    class IpLookup < ActiveRecord::Base
      self.table_name = 'traffic.ip_lookups'

      lookup_for :ip_address, class_name: IpAddress
      lookup_for :domain,     class_name: Domain

      belongs_to :location
    end
  end
end