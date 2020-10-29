prawn_document(page_size: 'A4', page_layout: :landscape) do |pdf|
  challenge_date = params[:date]
  title = "Sodbury Challenge #{Date.parse(challenge_date).year} " \
    '- Master Checkpoint List'

  pdf.text title, align: :center, style: :bold, size: 24

  pdf.table(
    [['No.', 'Section (Points)', 'Grid Ref', 'Description']],
    width: 800,
    column_widths: [40, 110, 80, 570],
    position: :center,
    cell_style: {
      font_style: :bold, border_color: 'DDDDDD', background_color: 'DDDDDD'
    }
  )

  @goals.each do |group, array|
    pdf.table(
      [[
        group,
        array.map { |a|
          a.challenge.time_allowed.to_s + ' (' + a.points_value.to_s + ')'
        }.to_sentence(two_words_connector: ' & '),
        array.first.checkpoint.grid_reference,
        array.first.checkpoint.description
      ]],
      width: 800,
      column_widths: [40, 110, 80, 570],
      row_colors: ['FFFFFF', 'F9F9F9'],
      position: :center,
      cell_style: { border_color: 'DDDDDD' }
    )
  end
end
