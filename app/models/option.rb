class Option < ActiveRecord::Base
  belongs_to :variant
  belongs_to :option_kind
end
