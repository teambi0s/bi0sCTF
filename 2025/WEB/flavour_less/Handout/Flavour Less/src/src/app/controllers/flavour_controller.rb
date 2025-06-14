class FlavourController < ApplicationController
  include ActionView::Helpers::SanitizeHelper
  def index
    user_input = params[:input]

    @sanitized_input = sanitize(user_input, tags: [ "math", "annotation-xml", "style" ])
  end
end
