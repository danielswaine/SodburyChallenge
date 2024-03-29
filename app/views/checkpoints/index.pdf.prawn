prawn_document(page_size: 'A4') do |pdf|
  current_time = Time.now.strftime('%R on %-d %B %Y')
  user = current_user.name

  pdf.text 'Sodbury Challenge Master Checkpoint List',
           align: :center, style: :bold, size: 18

  pdf.move_down 12

  pdf.text "Exported at #{current_time} by #{user}. Do not distribute.",
           align: :center, size: 14

  pdf.move_down 18

  pdf.table(
    [['No.', 'Grid Reference', 'Description']],
    width: 525,
    column_widths: [30, 100, 395],
    position: :center,
    cell_style:
    {
      font_style: :bold,
      border_color: 'DDDDDD',
      background_color: 'DDDDDD'
    }
  )

  unless @checkpoints.empty?
    pdf.table(
      @checkpoints.map do |checkpoint|
        [checkpoint.number, checkpoint.grid_reference, checkpoint.description]
      end,
      width: 525,
      row_colors: ['FFFFFF', 'F9F9F9'],
      cell_style: { border_color: 'DDDDDD' },
      column_widths: [30, 100, 395],
      position: :center
    )
  end
end
