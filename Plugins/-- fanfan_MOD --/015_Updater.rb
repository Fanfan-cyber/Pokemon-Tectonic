module Updater
  def self.need_update?
    return false
  end

  def self.update
    return
    Thread.new {
      file_name = @@download_url[@@download_url.rindex("/") + 1, @@download_url.length - 1]
      file_type = @@download_url[@@download_url.rindex(".") + 1, @@download_url.length - 1]
      if pbDownloadToFile(@@download_url, file_name) && file_type == "zip"
        system("start /min cmd.exe /c %0 & tar -xzvf " + file_name)
        File.delete(file_name)
      end
    }
    pbSEPlay("GUI naming confirm")
    pbWait(60)
    Thread.new { system("Game") }
    exit
  end
end