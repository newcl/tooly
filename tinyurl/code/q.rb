
ALPH=[('A'..'Z'), ('a'..'z'), (0..9)].map { |r| r.to_a }.reduce(['.', '+', '-', '_'], :concat)

# puts ALPH

def dd
  (1..6).each do |len|
    gen(0, len)
  end
end

def gen(cur_len, target_len, data=[])
  if cur_len >= target_len
    puts data.join('')
    return
  end

  ALPH.each do |c|
    data << c
    gen(cur_len+1, target_len, data)
    data.pop
  end
end

dd