if defined?(AssetSync)
  AssetSync.configure do |config|
    config.fog_provider = 'AWS'
    config.aws_access_key_id = ENV['S3_KEY']
    config.aws_secret_access_key = ENV['S3_SECRET']
    config.fog_directory = ENV['S3_BUCKET']
    config.gzip_compression = true
    config.fail_silently = true
  end
end

