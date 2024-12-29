module PBDebug
  @@log = []

  def self.logonerr
      begin
        yield
        return true
      rescue
        PBDebug.log("")
        PBDebug.log("**Exception: #{$!.message}")
        PBDebug.log("#{$!.backtrace.inspect}")
        PBDebug.log("")
  #      if $INTERNAL
          pbSEPlay("PC close")
          pbPrintException($!)
  #      end
        PBDebug.flush
        return false
      end
    end

  def self.flush
    if $DEBUG && $INTERNAL && @@log.length>0
      File.open("Data/debuglog.txt", "a+b") { |f| f.write("#{@@log}") }
    end
    @@log.clear
  end

  def self.log(msg)
    if $DEBUG
      echoln("#{msg}\n")
	  if $INTERNAL
      @@log.push("#{msg}\r\n")
      PBDebug.flush
      end
    end
  end

  def self.dump(msg)
    if $DEBUG && $INTERNAL
      File.open("Data/dumplog.txt", "a+b") { |f| f.write("#{msg}\r\n") }
    end
  end
end
