prawn_document(page_size: "A4") do |pdf|
	pdf.text "Sodbury Challenge Master Checkpoint List", align: :center, style: :bold, size: 18
	pdf.move_down 12
	pdf.text "Exported at #{Time.now.strftime("%R on %-d %B %Y")} by #{current_user.name}. Do not distribute.",
	        align: :center, size: 14

	pdf.move_down 18

	pdf.define_grid(:columns => 6, :rows => 25, :gutter => 10)
	#pdf.grid.show_all

	pdf.grid(3, 0).bounding_box do
		pdf.text "Number"
	end
	pdf.grid([3, 1], [3, 2]).bounding_box do
		pdf.text "Grid Reference"
	end
	pdf.grid([3, 3], [3, 4]).bounding_box do
		pdf.text "Description"
	end


	#for i in 1..21

	#	@checkpoint = Checkpoint.find(i)
	#	pdf.grid(j, 0).bounding_box do
	#		pdf.text "#{@checkpoint.number}"
	#	end

	#end

	pdf.table([
		["Number", "Grid Reference", "Description"],
		@checkpoints.each do |checkpoint|
			["#{checkpoint.number}", "short", "loooooooooooooooooooong"],
		end
		["last", "available", "row"]
	])
end
