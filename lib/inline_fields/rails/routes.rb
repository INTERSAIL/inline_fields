module ActionDispatch
  module Routing
    class Mapper
      def inline_route_for(resource)
        r = resource.to_s
        get "/#{r.singularize}/form_for", to: "#{r}#form_for", as: "form_for_#{r}"
        post "/#{r.singularize}/form_for", to: "#{r}#form_for_update", as: "form_for_update_#{r}"
      end
    end
  end
end