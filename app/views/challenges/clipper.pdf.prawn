prawn_document(page_size: "A4") do |pdf|

  pdf.define_grid(:columns => 8, :rows => 15, :gutter => 0)
  #pdf.grid.show_all

  row_location = [1, 6, 11]
  title_location = [0, 5, 10]

  row_location.each_with_index do |row, title|
    pdf.grid([title_location[title], 0], [title_location[title], 7]).bounding_box do
      pdf.draw_text "Sodbury Challenge #{@challenge.date.strftime('%Y')} - #{@challenge.time_allowed} Hour - Clipper Sheet", at: [10, 10], valign: :bottom, size: 22, style: :bold
    end

    x = row; y = 0
    @challenge.goals.where(start_point: false).each do |goal|
      pdf.grid(x, y).bounding_box do
        pdf.stroke_bounds
        pdf.draw_text "#{goal.checkpoint_id}", at: [2, 40]
        y += 1;
        if y == 8 then x += 1; y = 0 end
      end
    end
  end

end
