class ApplicationController < ActionController::Base
  include Pagy::Backend
  include ErrorHandling
  include Authentication # 93
end
