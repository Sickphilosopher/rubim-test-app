Rubim.configure do |c|
	blocks_dir = File.join(File.dirname(__FILE__), 'blocks')
	c.bundles = {
		main: Rubim::Bundle.new({
			levels: {
				common: File.join(blocks_dir, 'app'),
				app: File.join(blocks_dir, 'app')
			}
		})
	}
end