%w{version address municipality}.each do |f|
  require "miami_dade_geo/#{f}"
end

# `MiamiDadeGeo` provides geospatial data access for Miami-Dade County.
module MiamiDadeGeo
end
