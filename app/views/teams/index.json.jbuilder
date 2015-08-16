json.array!(@teams) do |team|
  json.extract! team, :id, :team_number, :name, :route_id, :score, :start_time, :due_end_time, :end_time, :due_phone_in_time, :phone_in_time, :team_year
  json.url team_url(team, format: :json)
end
