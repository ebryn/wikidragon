def run( cmd )
  cmd = "#{cmd} 2>&1"
  puts "Executing [#{cmd}]"
  output = `#{cmd}`
  if $?.success?
    puts output
  else
    raise "ERROR WHILE RUNNING SHELL COMMAND => [#{cmd}] <=\n"+
        "Output follows:\n" +
        '=' * 40 + "\n" +
        output.strip + "\n" +
        '=' * 40 + "\n"
  end
end
