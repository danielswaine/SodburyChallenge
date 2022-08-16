prawn_document(page_size: 'A4') do |pdf|
  be_prepared_img = "#{Rails.root}/app/assets/images/scouts_be_prepared.png"
  scout_logo_img = "#{Rails.root}/app/assets/images/scouts_logo.png"
  signature_img = "#{Rails.root}/app/assets/images/signature.jpg"
  year = @team.challenge.date.strftime('%Y')

  # Styles
  pdf.line_width 10
  pdf.stroke_color '473061'

  @team.members.each_with_index do |member, idx|
    pdf.start_new_page unless idx.zero?

    # Page Border
    pdf.bounding_box([0, 770], width: 515, height: 770) do
      pdf.stroke_bounds

      pdf.move_down 20

      pdf.image be_prepared_img, scale: 0.4, position: :center

      pdf.move_down 70

      pdf.text 'This certificate is awarded to', align: :center, size: 20

      pdf.move_down 30

      pdf.text member.name.to_s, align: :center, style: :bold, size: 24

      pdf.move_down 15

      pdf.text @team.name.to_s, align: :center, size: 20, style: :italic

      pdf.move_down 30

      pdf.text "for completing the Sodbury Challenge #{year}",
               align: :center, style: :bold, size: 20

      pdf.move_down 20

      pdf.image scout_logo_img, scale: 0.1, position: :center

      pdf.image signature_img, position: :right, at: [400, 90], scale: 0.6

      pdf.bounding_box([15, 30], width: 300, height: 20) do
        pdf.text member.team.challenge.date.to_formatted_s(:long_ordinal),
                 size: 14
      end

      pdf.bounding_box([100, 50], width: 400, height: 20) do
        pdf.text 'Daniel Swaine', size: 14, align: :right
      end

      pdf.bounding_box([100, 30], width: 400, height: 20) do
        pdf.text 'On behalf of 1st Chipping Sodbury Scout Group',
                 size: 14, align: :right
      end
    end
  end
end
