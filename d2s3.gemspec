spec = Gem::Specification.new do |s|
  s.name = 'd2s3'
  s.version = '0.0.1'
  s.summary = "Rails form helper to upload files directly to Amazon S3 using HTTP POST"
  s.files = Dir['lib/**/*.rb'] + Dir['test/**/*.rb']
  s.require_path = 'lib'
end
