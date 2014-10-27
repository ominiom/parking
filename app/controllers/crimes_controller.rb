class CrimesController < ApplicationController

  def score
    begin
      latitude  = Float(scoring_params[:latitude])
      longitude = Float(scoring_params[:longitude])
      radius    = Float(scoring_params[:radius]) rescue 3.0
    rescue
      head :bad_request
      return
    end

    since = 3.months.ago

    crimes = Crime
      .near([latitude, longitude], radius, select_distance: true)
      .where('year > :year OR (year = :year AND month >= :month)', year: since.year, month: since.month)
      .where(kind: 'Vehicle crime')

    score = crimes.map do |crime|
      date = Date.new(crime.year, crime.month, 15)
      age  = (Date.today - date).to_f
      age  = [[age, 0].max, 90].min / 90.0

      (1.0 - Math.log(10.0 / radius * crime.distance, 10)) * (age ** 3)
    end.compact.sum

    score = 100.0 - (100.0 / crimes.count(:all) * score)

    grade = case score
    when 90..100
      'A'
    when 70...90
      'B'
    when 50...70
      'C'
    when 40...50
      'D'
    when 30...40
      'E'
    else
      'F'
    end

    render json: {
      crimes: crimes.count(:all),
      score: score,
      grade: grade
    }
  end

  private

  def scoring_params
    params.permit(:latitude, :longitude, :radius)
  end

end
