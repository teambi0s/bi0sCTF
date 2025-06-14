class Setting < ApplicationRecord
  belongs_to :user

  validates :user_id, uniqueness: true
  validates :file_path, presence: true, allow_nil: true

  def initialize(attributes = nil)
    super
    @isolated = false if isolated.nil?
    @random = false if random.nil?
    @extension = false if extension.nil?
  end
end