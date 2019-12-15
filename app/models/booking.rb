class Booking < ApplicationRecord
  belongs_to :apartment, inverse_of: :bookings

  VALID_DATE_REGEX = /([12]\d{3}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01]))/i

  validates :start_date, presence: true, format: { with: VALID_DATE_REGEX }

  validates :end_date, presence: true, format: { with: VALID_DATE_REGEX }

  validates :apartment_id, presence: true

  validate :allow_dates, :bookings_must_not_overlap


  private
  def allow_dates
    if end_date <= start_date
      errors.add(:end_date, "can't be past or equal to start date")
    end
  end

  def bookings_must_not_overlap
    overlap_relation = Booking.where(apartment_id: apartment_id)
                           .where(
                               'DATE(bookings.start_date) < DATE(?) AND DATE(bookings.end_date) > DATE(?)',
                               end_date, start_date
                           )

    if overlap_relation.exists?
      errors.add(:start_date, "canot overlap another booking for this apartment")
    end
  end
end
