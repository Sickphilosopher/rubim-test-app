module Blocks
	module Common
		Title = Rubim::Template.match({block: 'title'}) do
			set_tag :title
		end
	end
end