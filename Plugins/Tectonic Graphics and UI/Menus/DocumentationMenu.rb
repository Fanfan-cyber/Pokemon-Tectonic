class PokemonDocumentationMenu_Scene
	def pbStartScene
		@viewport = Viewport.new(0,0,Graphics.width,Graphics.height)
		@viewport.z = 99999
		@sprites = {}
		@sprites["cmdwindow"] = Window_CommandPokemon.new([])
		@sprites["cmdwindow"].visible = false
		@sprites["cmdwindow"].viewport = @viewport
		@infostate = false
		@helpstate = false
		pbSEPlay("GUI menu open")
	  end
	
	  def pbShowCommands(commands)
		ret = -1
		cmdwindow = @sprites["cmdwindow"]
		cmdwindow.commands = commands
		cmdwindow.index    = $PokemonTemp.menuLastChoice
		cmdwindow.resizeToFit(commands)
		cmdwindow.x        = Graphics.width-cmdwindow.width
		cmdwindow.y        = 0
		cmdwindow.visible  = true
		loop do
		  cmdwindow.update
		  Graphics.update
		  Input.update
		  pbUpdateSceneMap
		  if Input.trigger?(Input::BACK)
			ret = -1
			break
		  elsif Input.trigger?(Input::USE)
			ret = cmdwindow.index
			$PokemonTemp.menuLastChoice = ret
			break
		  end
		end
		return ret
	end
	
	def pbEndScene
		pbDisposeSpriteHash(@sprites)
		@viewport.dispose
	end

	def pbRefresh; end
end

class PokemonDocumentationMenu < PokemonPauseMenu
	def pbStartPokemonMenu
		if !$Trainer
			if $DEBUG
			  pbMessage(_INTL("The player trainer was not defined, so the pause menu can't be displayed."))
			  pbMessage(_INTL("Please see the documentation to learn how to set up the trainer player."))
			end
			return
		end
    @scene.pbStartScene
    endscene = true
    cmdMasterDex   = -1
    cmdMoveDex     = -1
    cmdAbilityDex  = -1
    cmdItemDex     = -1
    cmdBattleGuide = -1
    cmdDimensionD  = -1
    cmdTimeCapsule = -1
    cmdBattleLoader = -1
    cmdTeamSwitcher = -1
    cmdGiftCode    = -1
    infoCommands = []
    infoCommands[cmdMasterDex   = infoCommands.length] = _INTL("MasterDex")
    infoCommands[cmdMoveDex     = infoCommands.length] = _INTL("MoveDex")
    infoCommands[cmdAbilityDex  = infoCommands.length] = _INTL("AbilityDex")
    infoCommands[cmdItemDex     = infoCommands.length] = _INTL("ItemDex")
    infoCommands[cmdBattleGuide = infoCommands.length] = _INTL("Battle Guide")
    infoCommands[cmdDimensionD  = infoCommands.length] = _INTL("Dimension D")
    infoCommands[cmdTimeCapsule = infoCommands.length] = _INTL("Time Capsule")
    infoCommands[cmdBattleLoader = infoCommands.length] = _INTL("Battle Loader")
    #infoCommands[cmdTeamSwitcher = infoCommands.length] = _INTL("Team Switcher")
    infoCommands[cmdGiftCode    = infoCommands.length] = _INTL("Gift Receiver")
    infoCommands.push(_INTL("Cancel"))
    loop do
      infoCommand = @scene.pbShowCommands(infoCommands)
      if cmdMasterDex > -1 && infoCommand == cmdMasterDex
          pbFadeOutIn {
              dexScene = PokemonPokedex_Scene.new
              screen = PokemonPokedexScreen.new(dexScene)
              screen.pbStartScreen
          }
      elsif cmdMoveDex > -1 && infoCommand == cmdMoveDex
          openMoveDex
      elsif cmdAbilityDex > -1 && infoCommand == cmdAbilityDex
          AbilityDex.open_abilitydex
      elsif cmdItemDex > -1 && infoCommand == cmdItemDex
          ItemDex.open_itemdex
      elsif cmdBattleGuide > -1 && infoCommand == cmdBattleGuide
          showBattleGuide
      elsif cmdDimensionD > -1 && infoCommand == cmdDimensionD
          DimensionD.open_dimension_d
      elsif cmdTimeCapsule > -1 && infoCommand == cmdTimeCapsule
          TimeCapsule.open_time_capsule
      elsif cmdBattleLoader > -1 && infoCommand == cmdBattleLoader
          BattleLoader.open_battle_loader
      elsif cmdTeamSwitcher > -1 && infoCommand == cmdTeamSwitcher
          TeamSwitcher.open_team_switcher
      elsif cmdGiftCode > -1 && infoCommand == cmdGiftCode
          CDKey.enter_cd_key
      else
        pbPlayCloseMenuSE
        break
      end
    end
    @scene.pbEndScene if endscene
  end

  def pbStartPokemonMenuInBattle
    $PokemonTemp.menuLastChoice = 0
		if !$Trainer
			if $DEBUG
			  pbMessage(_INTL("The player trainer was not defined, so the pause menu can't be displayed."))
			  pbMessage(_INTL("Please see the documentation to learn how to set up the trainer player."))
			end
			return
		end
    @scene.pbStartScene
    endscene = true
    cmdMasterDex   = -1
    cmdMoveDex     = -1
    cmdAbilityDex  = -1
    cmdItemDex     = -1
    cmdBattleGuide = -1
    infoCommands = []
    infoCommands[cmdMasterDex   = infoCommands.length] = _INTL("MasterDex")
    infoCommands[cmdMoveDex     = infoCommands.length] = _INTL("MoveDex")
    infoCommands[cmdAbilityDex  = infoCommands.length] = _INTL("AbilityDex")
    infoCommands[cmdItemDex     = infoCommands.length] = _INTL("ItemDex")
    infoCommands[cmdBattleGuide = infoCommands.length] = _INTL("Battle Guide")
    infoCommands.push(_INTL("Cancel"))
    loop do
      infoCommand = @scene.pbShowCommands(infoCommands)
      if cmdMasterDex > -1 && infoCommand == cmdMasterDex
          pbFadeOutIn {
              dexScene = PokemonPokedex_Scene.new
              screen = PokemonPokedexScreen.new(dexScene)
              screen.pbStartScreen
          }
      elsif cmdMoveDex > -1 && infoCommand == cmdMoveDex
          openMoveDex
      elsif cmdAbilityDex > -1 && infoCommand == cmdAbilityDex
          AbilityDex.open_abilitydex
      elsif cmdItemDex > -1 && infoCommand == cmdItemDex
          ItemDex.open_itemdex
      elsif cmdBattleGuide > -1 && infoCommand == cmdBattleGuide
          showBattleGuide
      else
        pbPlayCloseMenuSE
        break
      end
    end
    @scene.pbEndScene if endscene
  end
end

def showDocumentationMenu
    docsMenuScene = PokemonDocumentationMenu_Scene.new
    docsMenuScreen = PokemonDocumentationMenu.new(docsMenuScene)
    docsMenuScreen.pbStartPokemonMenuInBattle
end