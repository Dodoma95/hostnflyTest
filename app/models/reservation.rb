class Reservation < ApplicationRecord
  belongs_to :apartment, inverse_of: :reservations

  VALID_DATE_REGEX = /([12]\d{3}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01]))/i

  validates :start_date, presence: true, format: { with: VALID_DATE_REGEX }

  validates :end_date, presence: true, format: { with: VALID_DATE_REGEX }

  validates :apartment_id, presence: true

  validate :allow_dates, :reservations_must_not_overlap


  private
  def allow_dates
    if !!start_date && !!end_date && end_date < start_date
      errors.add(:end_date, "cannot be past to start_date")
    end
  end

  def reservations_must_not_overlap
    overlap_relation = Reservation.where(apartment_id: apartment_id)
                           .where(
                               'DATE(reservations.start_date) < DATE(?) AND DATE(reservations.end_date) > DATE(?)',
                               end_date, start_date
                           )

    if overlap_relation.exists?
      errors.add(:start_date, "canot overlap another reservation for this apartment")
    end
  end
end
