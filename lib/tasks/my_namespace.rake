namespace :my_namespace do

    desc "populate DB from JSON file"
    task populate: :environment do
      json_path = File.join("lib/data/input.json")
      json_content = File.read(json_path)
      json_input = JSON.parse(json_content)

      json_input['apartments'].each do |apartment|
        Apartment.create!(apartment)
      end

      json_input['bookings'].each do |booking|
        Booking.create!(booking)
      end

      json_input['reservations'].each do |reservation|
        Reservation.create!(reservation)
      end
    end
end

