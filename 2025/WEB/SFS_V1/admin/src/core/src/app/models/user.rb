class User < ApplicationRecord
  validates :username, presence: true, uniqueness: true
  validates :url, presence: true

  has_one :setting, dependent: :destroy
end
