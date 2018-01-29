module Blocks
	module Common
		Html = Rubim::Template.match({block: 'html'}) do
			set_content do
				[
					{block: 'head', content: {block: 'title', content: opts[:title]}},
					{block: 'body', content: content}
				]
			end
		end
	end
end