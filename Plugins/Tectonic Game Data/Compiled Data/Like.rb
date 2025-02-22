module Compiler
	module_function
  
	def compile_likes(path = "PBS/likes.txt")
		GameData::Like::DATA.clear
		likeNames = []
		likeNumber = 0
		baseFiles = [path]
		likeTextFiles = []
		likeTextFiles.concat(baseFiles)
		likeExtensions = Compiler.get_extensions("likes")
		likeTextFiles.concat(likeExtensions)
		likeTextFiles.each do |path|
			baseFile = baseFiles.include?(path)
			pbCompilerEachCommentedLine(path) { |line, line_no|
				line = pbGetCsvRecord(line, line_no, [0, "*ns"])
				like_symbol = line[0].to_sym
				if GameData::Like::DATA[like_symbol]
					raise _INTL("Pokemon like ID '{1}' is used twice.\r\n{2}", like_symbol, FileLineData.linereport)
				end
				like_hash = {
					:id          => like_symbol,
					:id_number	 => likeNumber,
					:real_name	 => line[1],
					:defined_in_extension => !baseFile
				}
				GameData::Like.register(like_hash)
				likeNames[likeNumber]        = like_hash[:real_name]
				likeNumber += 1
			}
		end
		# Save all data
		GameData::Like.save
		MessageTypes.setMessages(MessageTypes::Likes, likeNames)
		Graphics.update
	end
end

module GameData
	class Like
		attr_reader :id
		attr_reader :id_number
		attr_reader :real_name
		attr_reader :defined_in_extension

		DATA = {}
		DATA_FILENAME = "likes.dat"

		extend ClassMethods
		include InstanceMethods

		def initialize(hash)
			@id = hash[:id]
			@id_number = hash[:id_number]
			@real_name = hash[:real_name]
			@defined_in_extension = hash[:defined_in_extension] || false
		end

		def name
			pbGetMessage(MessageTypes::Likes, @id_number)
		end

		def self.getRandomLike
			like = DATA.values.sample
			return like if $DEBUG
			while like.id.start_with?("DEBUG_") do
				like = DATA.values.sample
			end
			return like
		end
	end
end
