class GlobalSwitchChanged < HandlerHashBasic
end

class GlobalVariableChanged < HandlerHashBasic
end

module GlobalStateHandlers
    GlobalSwitchChanged   = HandlerHashBasic.new
    GlobalVariableChanged = HandlerHashBasic.new
    
    #=============================================================================

    def self.triggerGlobalSwitchChanged(switchID,value)
        GlobalSwitchChanged.trigger(switchID,switchID,value)
    end
      
    def self.triggerGlobalVariableChanged(variableID,value)
        GlobalVariableChanged.trigger(variableID,variableID,value)
    end
end