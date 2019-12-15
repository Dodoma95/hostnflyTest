class Mission < ApplicationRecord
  belongs_to :apartment, inverse_of: :missions

  class MissionType
    FIRST_CHECKIN = 'first_checkin'
    LAST_CHECKOUT = 'last_checkout'
    CHECKOUT_CHECKIN = 'checkout_checkin'

    def self.values
      [FIRST_CHECKIN, LAST_CHECKOUT, CHECKOUT_CHECKIN]
    end
  end

  VALID_DATE_REGEX = /([12]\d{3}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01]))/i

  validates :date, presence: true, format: { with: VALID_DATE_REGEX }

  validates :price, presence: true

  validates :apartment_id, presence: true

  validates :mission_type, inclusion: {
      in: MissionType.values,
      message: "%{value} is not a valid mission_type"
  }

end
