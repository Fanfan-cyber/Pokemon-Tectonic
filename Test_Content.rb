# This is a newly created file.
class Array
  def sort_by_chs
    sort_by { |s| Pinyin.t(s, tone: true) }
  end
end

def ddd
  aaa = ["傻B", "白痴", "笨蛋", "猪头", "天才"]
  pbMessage(_INTL("{1}", aaa.sort_by_chs.join(" ")))
end