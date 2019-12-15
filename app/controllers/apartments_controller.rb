class ApartmentsController < ApplicationController
#sert a donner accès a une méthode en précisant les méthodes qui pourront l'utiliser
before_action :set_apartment, only: [:edit, :update, :show, :destroy]
require 'json'

def index
  @apartments = Apartment.all
end

def edit
end

def new
  @apartment = Apartment.new
end

def create
  @apartment = Apartment.new(apartment_params)

  respond_to do |format|
    if @apartment.save
      format.html { redirect_to apartment_path(@apartment), notice: 'Apartment was successfully created.' }
      format.json { render :show, status: :created, location: apartment_path(@apartment) }
    else
      format.html { render :new }
      format.json { render json: @apartment.errors, status: :unprocessable_entity }
    end
  end
end

def update

  respond_to do |format|
    if @apartment.update(apartment_params)
      format.html { redirect_to apartment_path(@apartment), notice: 'Apartment was successfully updated.' }
      format.json { render :show, status: :ok, location: apartment_path(@apartment) }
    else
      format.html { render :edit }
      format.json { render json: @apartment.errors, status: :unprocessable_entity }
    end
  end
end


def show
end

def destroy
  @apartment.destroy
  respond_to do |format|
    format.html { redirect_to apartments_path, notice: 'Apartment was successfully destroyed.' }
    format.json { head :no_content }
  end
end


#Factorisation de code récurrent
private
#cf before_action qui définit les méthodes qui auront accès a cette méthode
def set_apartment
  @apartment = Apartment.find(params[:id])
end

def apartment_params
  #défini les params de l'article
  params.require(:apartment).permit(:num_rooms)
end

end
