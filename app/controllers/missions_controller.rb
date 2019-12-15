class MissionsController < ApplicationController
  before_action :set_mission, only: [:show]
  require 'json'

  def index
    @missions = Mission.all
  end


  def new
    @mission = Mission.new
  end


  def show
  end

  def create
    tempHash = []

    Mission.delete_all

    generate

    Mission.all.each do |mission|
      tempHash << {
          "id" => "#{mission.id}",
          "apartment_id" => "#{mission.apartment_id}",
          "mission_type" => "#{mission.mission_type}",
          "price" => "#{mission.price}",
          "date" => "#{mission.date}"
      }
    end

    write_hash_to_pretty_json_file(tempHash, "lib/data/output.json")
    redirect_to missions_path
  end

  private

  def write_hash_to_pretty_json_file(hash, filename)
    File.open(filename,"w") do |f|
      f.write(JSON.pretty_generate(hash))
    end
  end

  def generate
    Apartment.all.each do |apartment|
      create_missions_from_bookings(apartment)
      create_missions_from_reservations(apartment)
    end
  end

  def mission_params
    params.require(:mission).permit(:mission_type, :date, :price, :apartment_id)
  end

  def set_mission
    @mission = Mission.find(params[:id])
  end

  def create_missions_from_bookings(apartment)
    apartment.bookings.each do |booking|
      apartment.missions.create!(
          mission_type: Mission::MissionType::FIRST_CHECKIN,
          date: booking.start_date,
          price: 10*apartment.num_rooms
      )

      apartment.missions.create!(
          mission_type: Mission::MissionType::LAST_CHECKOUT,
          date: booking.end_date,
          price: 5*apartment.num_rooms
      )
    end
  end

  def create_missions_from_reservations(apartment)
    Reservation.joins(apartment: :bookings)
        .where('DATE(reservations.start_date) >= DATE(bookings.start_date) AND DATE(reservations.end_date) < DATE(bookings.end_date)')
        .where(apartments: {id: apartment.id})
        .each do |reservation|
      apartment.missions.create!(
          mission_type: Mission::MissionType::CHECKOUT_CHECKIN,
          date: reservation.end_date,
          price: 10*apartment.num_rooms
      )
    end
  end
end
