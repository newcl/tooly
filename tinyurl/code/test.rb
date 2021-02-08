a = [1,2,3]

a.each do |v|
  puts v
  begin
    raise 'hello'
  rescue => e
    puts e
  end

end