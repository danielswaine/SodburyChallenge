prawn_document(page_size: "A4") do |pdf|
  count = 1
  challenge_date = params[:date]
  @challenges.where(date: challenge_date).order(:time_allowed).each_with_index do |challenge, idx|
    pdf.start_new_page unless idx == 0
    pdf.text "Sodbury Challenge #{challenge.date.year} -  #{challenge.time_allowed} Hour Start Times", align: :center, style: :bold, size: 18
    pdf.move_down 12
    pdf.text "Last Updated at #{Time.now.strftime("%R")}",
            align: :center, size: 14
    pdf.move_down 18
    pdf.table(
      [["No.", "Team Name", "Planned Start Time", "Expected Finish Time"]],
      :width => 525, :column_widths => [50, 305, 85, 85],  :position => :center,
      :cell_style => { :font_style => :bold, :border_color => "DDDDDD", :background_color => "DDDDDD" }
    )
    challenge.teams.order(:planned_start_time).each do |team|
      pdf.table(
        [[count, team.name, team.planned_start_time, expected_finish_time_with_padding(team)]],
        :width => 525, :column_widths => [50, 305, 85, 85], :position => :center,
        :cell_style => { :border_color => "DDDDDD" }
      )
      count += 1
    end
  end
end
