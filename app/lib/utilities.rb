# encoding: utf-8
def depth_indicator(before, after)
  "#{" " * before}┗#{"━" * after}" if before > 0
end