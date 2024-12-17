# This is a newly created file.
require './gems/chinese_pinyin-1.1.0/lib/chinese_pinyin'
def ddd
  aaa = Pinyin.t("爱而不得", tone: true)
  pbMessage(_INTL("Failed to reload: An error occurred.\n({1})", aaa))
end