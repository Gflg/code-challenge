class Invoice < ApplicationRecord
    has_many :emails, dependent: :destroy
    accepts_nested_attributes_for :emails, reject_if: :all_blank
end
