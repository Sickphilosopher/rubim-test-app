require 'rack/utils'

def load_block(level, name)
	Unreloader.require "./blocks/#{level}/#{name}/#{name}.rb"
end

load_block(:common, :body)
load_block(:common, :html)

class App < Roda
	def initialize(*attrs)
		@cache = {}
		@views = {
			hello: {
				block: 'html',
				title: 'Заголовок',
				content: [
					block: 'test',
					content: [
						{
							block: 'test2',
							content: 'ls'
						},
						{
							block: 'test3',
							content: 'boo'
						}
					]
				]
			}
		}
		@bundle = Rubim.config.bundles[:main]
		@bundle.add(Blocks::Common::Body)
		@bundle.add(Blocks::Common::Html)
		@entry_tree_builder = Rubim::EntryTreeBuilder.new(@bundle)
		@html_tree_builder = Rubim::HtmlTreeBuilder.new
		@renderer = Rubim::Renderer.new
		super(*attrs)
	end

	def render(view)
		template = @views[view]
		entry_tree = @entry_tree_builder.build(template)
		html_tree = @html_tree_builder.build(entry_tree)
		html_tree.inspect
		result = @renderer.render(html_tree)
		# @cache[view] ||= begin
		# 	content = File.read(File.join(File.dirname(__FILE__), 'views', view.to_s + '.yml'))
		# end
	end

	route do |r|
		# GET / request
		r.root do
			r.redirect "/hello"
		end

		# /hello branch
		r.on "hello" do
			# Set variable for all routes in /hello branch
			@greeting = 'Hello'

			# GET /hello/world request
			r.get "world" do
				"#{@greeting} world!"
			end

			# /hello request
			r.is do
				# GET /hello request
				r.get do
					"<pre>#{Rack::Utils.escape_html(render(:hello))}</pre>"
				end

				# POST /hello request
				r.post do
					puts "Someone said #{@greeting}!"
					r.redirect
				end
			end
		end
	end
end