def capture_stdout &block
  old_stdout = $stdout
  fake_stdout = StringIO.new
  $stdout = fake_stdout
  block.call
  fake_stdout.string
ensure
  $stdout = old_stdout
end

def capture_stderr &block
  old_stderr = $stderr
  fake_stderr = StringIO.new
  $stderr = fake_stderr
  block.call
  fake_stderr.string
ensure
  $stderr = old_stderr
end
