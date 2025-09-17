prawn_document(page_size: 'A4', page_layout: :landscape) do |pdf|
  challenge_date = params[:date]
  title = "Sodbury Challenge #{Date.parse(challenge_date).year} " \
    '- Master Checkpoint List'
  table_widths = [40, 110, 80, 570]

  pdf.text title, align: :center, style: :bold, size: 24

  pdf.table(
    [['No.', 'Section (Points)', 'Grid Ref', 'Description']],
    width: 800,
    column_widths: table_widths,
    position: :center,
    cell_style: {
      font_style: :bold,
      border_color: 'DDDDDD',
      background_color: 'DDDDDD'
    }
  )

  def format_checkpoint_section_points(array)
    sections = array.map do |a|
      start = a.start_point ? ' Start' : ''
      compulsory = a.compulsory ? ' Comp' : ''
      time_allowed = "#{a.challenge.time_allowed}hr"
      points_value = a.points_value.to_s

      "#{time_allowed}#{start}#{compulsory} (#{points_value})"
    end

    sections.to_sentence(two_words_connector: ', ')
  end

  unless @goals.empty?
    pdf.table(
      @goals.map do |_group, array|
        [
          array.first.checkpoint.number,
          format_checkpoint_section_points(array),
          array.first.checkpoint.grid_reference,
          array.first.checkpoint.description
        ]
      end,
      width: 800,
      column_widths: table_widths,
      row_colors: %w[FFFFFF F9F9F9],
      position: :center,
      cell_style: { border_color: 'DDDDDD' }
    )
  end
end
