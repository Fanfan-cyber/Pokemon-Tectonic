if Settings::ER_MODE

#CONFIG
#search uses either this key or "Special"
SEARCHKEY = :TAB
#if true, a search with only results will be automatically confirmed instead of just selecting it in the list
ItemsSearch_Autoconfirm = true


module Input
  unless defined?(old_update_method)
    class << Input
	#keep track of normal update function
      alias old_update_method update
    end
    end
	
	#should be kept same as pbChooseItem in PokemonBag_Scene.rb if that one changes
	PokemonBag_Scene.class_eval do 
     define_method(:pbChooseItem)   do
		 
		 
		@sprites["helpwindow"].visible = false
        itemwindow = @sprites["itemlist"]
        thispocket = @bag.pockets[itemwindow.pocket]
        swapinitialpos = -1
        pbActivateWindow(@sprites,"itemlist") {
          loop do
            oldindex = itemwindow.index
            Graphics.update
            Input.update
            pbUpdate
            if itemwindow.sorting && itemwindow.index>=thispocket.length
              itemwindow.index = (oldindex==thispocket.length-1) ? 0 : thispocket.length-1
            end
             if itemwindow.index!=oldindex
              # Move the item being switched
              if itemwindow.sorting
                thispocket.insert(itemwindow.index,thispocket.delete_at(oldindex))
              end
              # Update selected item for current pocket
              @bag.setChoice(itemwindow.pocket,itemwindow.index)
              pbRefresh
            end
            if itemwindow.sorting
              if Input.trigger?(Input::ACTION) ||
                 Input.trigger?(Input::USE)
                itemwindow.sorting = false
                pbPlayDecisionSE
                pbRefresh
              elsif Input.trigger?(Input::BACK)
                thispocket.insert(swapinitialpos,thispocket.delete_at(itemwindow.index))
                itemwindow.index = swapinitialpos
                itemwindow.sorting = false
                pbPlayCancelSE
                pbRefresh
              end
            else
              # Change pockets
              if Input.trigger?(Input::LEFT)
                newpocket = itemwindow.pocket
                loop do
                  newpocket = (newpocket==1) ? PokemonBag.numPockets : newpocket-1
                  break if !@choosing || newpocket==itemwindow.pocket
                  if @filterlist
                    break if @filterlist[newpocket].length>0
                  else
                    break if @bag.pockets[newpocket].length>0
                  end
                end
                if itemwindow.pocket!=newpocket
                  itemwindow.pocket = newpocket
                  @bag.lastpocket   = itemwindow.pocket
                  thispocket = @bag.pockets[itemwindow.pocket]
                  pbPlayCursorSE
                  pbRefresh
                end
              elsif Input.trigger?(Input::RIGHT)
                newpocket = itemwindow.pocket
                loop do
                  newpocket = (newpocket==PokemonBag.numPockets) ? 1 : newpocket+1
                  break if !@choosing || newpocket==itemwindow.pocket
                  if @filterlist
                    break if @filterlist[newpocket].length>0
                  else
                    break if @bag.pockets[newpocket].length>0
                  end
                end
                if itemwindow.pocket!=newpocket
                  itemwindow.pocket = newpocket
                  @bag.lastpocket   = itemwindow.pocket
                  thispocket = @bag.pockets[itemwindow.pocket]
                  pbPlayCursorSE
                  pbRefresh
                end
              elsif Input.trigger?(Input::ACTION)   # Start switching the selected item
                if !@choosing
                  if thispocket.length>1 && itemwindow.index<thispocket.length &&
                      $PokemonSystem.bag_sorting == 0
                    itemwindow.sorting = true
                    swapinitialpos = itemwindow.index
                    pbPlayDecisionSE
                    pbRefresh
                  else
                    pbPlayBuzzerSE
                  end
                end
              elsif Input.trigger?(Input::BACK)   # Cancel the item screen
                pbPlayCloseMenuSE
                return nil
              elsif Input.trigger?(Input::USE)   # Choose selected item
                (itemwindow.item) ? pbPlayDecisionSE : pbPlayCloseMenuSE
                return itemwindow.item
				
			  ##NEW CODE STARTS HERE
              elsif Input.trigger?(Input::SPECIAL) || Input.triggerex?(SEARCHKEY)   # Search form
			   searchText = pbEnterText("Search by description!",0,999)
			   thispocket = @bag.pockets[itemwindow.pocket]
			   if searchText != ""
				  searchText = searchText.downcase
				  #pocket contents look like [[:SEVENLEAGUEBOOTS, 1], [:AGILITYHERB, 1], [:AIRBALLOON, 1], [:ASPEARBERRY, 1], [:BUGGEM, 1], [:CADOBERRY, 1], [:CHERIBERRY, 1].....
				  matchedIndexes = []
				  matchedItems  =  []
				  thispocket.each_with_index do |potentialItem, potentialIndex|
					description = GameData::Item.get(potentialItem[0]).name.downcase + GameData::Item.get(potentialItem[0]).description.downcase
					if description.to_s.include?searchText 
						matchedIndexes.push(potentialIndex)
						matchedItems.push(potentialItem[0])
					end
				  end
				  
				  #version 1: navigate to next
				  if false && matchedIndexes.length > 0
					  matchedIndexes = matchedIndexes.sort
					 # pbMessage(matchedIndexes.to_s)
					 # pbMessage(itemwindow.index.to_s)
					  #try to navigate to first item after current, if not then first of list, to help repeat searches
					  bestIndex = matchedIndexes[0];
					  matchedIndexes.each do |matchedIndex|
						if matchedIndex > itemwindow.index
						bestIndex = matchedIndex
						break
						end
					  end
					 # pbMessage("New choice " + bestIndex.to_s)
					  itemwindow.index = bestIndex
					  @bag.setChoice(itemwindow.pocket,bestIndex)
					  pbRefresh
				  end
				  
				  #version 2: sublist
				  if matchedIndexes.length == 1
						itemwindow.index = matchedIndexes[0]
						@bag.setChoice(itemwindow.pocket,matchedIndexes[0])
						pbRefresh
						if ItemsSearch_Autoconfirm == true
							pbPlayDecisionSE
							return itemwindow.item
						end
				  end
    			  if matchedIndexes.length > 1
					  itemId = pbChooseItemFromListWithoutVar("Search Results",*matchedItems)
					  if itemId != nil #output like :PECHABERRY
						thispocket.each_with_index do |potentialItem, potentialIndex|
							if potentialItem[0] == itemId 
								itemwindow.index = potentialIndex
								@bag.setChoice(itemwindow.pocket,potentialIndex)
								pbRefresh
								if ItemsSearch_Autoconfirm == true
									pbPlayDecisionSE
									return itemwindow.item
								end
							end
						end
					  end
				  end
				  ##NEW CODE ENDS AROUND HERE

				end

              end
            end
          end
        }
		 
		 
    end
end

#based on ItemFunctions pbChooseItemFromList
PokemonBag_Scene.class_eval do 
     define_method(:pbChooseItemFromListWithoutVar)   do |message, *args|
  commands = []
  itemid   = []
  for item in args
    next if !GameData::Item.exists?(item)
    itm = GameData::Item.get(item)
    next if !$PokemonBag.pbHasItem?(itm)
    commands.push(itm.name)
    itemid.push(itm.id)
  end
  if commands.length == 0
    return nil
  end
  commands.push(_INTL("Cancel"))
  itemid.push(nil)
  ret = pbMessage(message, commands, -1)
  if ret < 0 || ret >= commands.length-1
    return nil
  end
  return itemid[ret]
end
end



 

  def self.update
    old_update_method
    if triggerex?(SEARCHKEY)   
	
	#DOCK_LOCATIONS[:BONGOLAND] = {
    #    :map_name => "Bongo Land",
    #    :map_id => 11,	
    #    :event_id => 1,
    #}
	
	#mapData = Compiler::MapData.new
	#map = mapData.getMap(11)
	#print(map.events.to_s)
#	pbMessage("Test" +Graphics.frame_rate.to_s ) 
	
	#boatTravel
    #    if Graphics.frame_rate==40
    #			Graphics.frame_rate=120
	#			$speed_up = true
	#	else
	#			$speed_up = false
	#		Graphics.frame_rate=40
    #    end
    end
  end#def self.update
  
  
  
end#module
  
   
   #GameCharacter.rb
       # def move_speed_real=(val)
        # @move_speed_real = val * 40.0 / Graphics.frame_rate
		# @move_speed_real = @move_speed_real * 3 if $speed_up
		 
    # end

end