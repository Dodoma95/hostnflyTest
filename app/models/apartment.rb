class Apartment < ActiveRecord::Base
  has_many :bookings, inverse_of: :apartment
  has_many :missions, inverse_of: :apartment
  has_many :reservations, inverse_of: :apartment

  validates :num_rooms, presence: true, length: { minimum: 1, maximum: 3}
end
