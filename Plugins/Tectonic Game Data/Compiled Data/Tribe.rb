module Compiler
	module_function

	def compile_tribes(path = "PBS/tribes.txt")
		tribe_names        = []
    tribe_descriptions = []
		GameData::Tribe::DATA.clear
		tribe_number = 0
		baseFiles = [path]
		tribeTextFiles = []
		tribeTextFiles.concat(baseFiles)
		policyExtensions = Compiler.get_extensions("tribes")
		tribeTextFiles.concat(policyExtensions)
		tribeTextFiles.each do |path|
			baseFile = baseFiles.include?(path)
			# Read each line of tribes.txt at a time and compile it
			pbCompilerEachCommentedLine(path) { |line, line_no|
				tribeSchema = [0, "*niss"]
				line = pbGetCsvRecord(line, line_no, tribeSchema)
				tribe_symbol = line[0].to_sym
				tribe_threshold = line[1].to_i
				tribe_name = line[2]
				tribe_description = line[3]
				if GameData::Tribe::DATA[tribe_symbol]
					raise _INTL("Tribe ID '{1}' is used twice.\r\n{2}", tribe_symbol, FileLineData.linereport)
				end
				# Construct tribe hash
				tribe_hash = {
					:id          => tribe_symbol,
					:id_number   => tribe_number,
					:threshold   => tribe_threshold,
					:description => tribe_description,
					:name		 => tribe_name,
					:defined_in_extension => !baseFile
				}
				# Add tribe's data to records
				GameData::Tribe.register(tribe_hash)
				tribe_names[tribe_number]        = tribe_name
				tribe_descriptions[tribe_number] = tribe_hash[:description]

				tribe_number += 1
			}
		end
		# Save all data
		GameData::Tribe.save
		Graphics.update

		MessageTypes.setMessages(MessageTypes::Tribes, tribe_names)
		MessageTypes.setMessages(MessageTypes::TribeDescriptions, tribe_descriptions)
	end
end

module GameData
	class Tribe
		attr_reader :id
		attr_reader :id_number
		attr_reader :threshold
		attr_reader :real_description
		attr_reader :real_name
		attr_reader :defined_in_extension

		DATA = {}
		DATA_FILENAME = "tribes.dat"

		extend ClassMethods
		include InstanceMethods

		def initialize(hash)
			@id = hash[:id]
			@id_number = hash[:id_number]
			@threshold = hash[:threshold]
			@real_description = hash[:description]
			@real_name = hash[:name]
			@defined_in_extension = hash[:defined_in_extension] || false
		end

		def name
			pbGetMessage(MessageTypes::Tribes, @id_number)
		end

		def description
			pbGetMessage(MessageTypes::TribeDescriptions, @id_number)
		end

    def threshold
      customtribethresh = TA.get(:customtribethresh)
      if customtribethresh && customtribethresh < @threshold
        customtribethresh
      else
        @threshold
      end
    end
	end
end
