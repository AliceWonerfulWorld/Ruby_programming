class Recipe < ApplicationRecord
    validates :title, presence: true
    validates :description, presence: true
    validates :ingredients, presence: true
    validates :instructions, presence: true
    validates :cook_time_minutes,
              numericality: { only_integer: true, greater_than_or_equal_to: 0 },
              allow_nil: true
end
