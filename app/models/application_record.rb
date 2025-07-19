class ApplicationRecord < ActiveRecord::Base
  include CustomErrors

  primary_abstract_class
end
