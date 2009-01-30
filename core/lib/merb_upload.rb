# make sure we're running inside Merb
if defined?(Merb::Plugins)

  require 'fileutils'

  module Merb
    module Upload
      class UploadError < StandardError; end
      class NoFileError < UploadError; end
      class FormNotMultipart < UploadError; end
      class InvalidParameter < UploadError; end
    end
  end

  dir = File.dirname(__FILE__) / 'merb_upload'
  require dir / 'sanitized_file'
  require dir / 'uploader'
  require dir / 'attachable_uploader'
  require dir / 'mountable_uploader'
  require dir / 'storage' / 'file'
  
  # Merb gives you a Merb::Plugins.config hash...feel free to put your stuff in your piece of it
  Merb::Plugins.config[:merb_upload] = {
    :storage => :file,
    :use_cache => true,
    :store_dir => Merb.root / 'public' / 'uploads',
    :cache_dir => Merb.root / 'public' / 'uploads' / 'tmp',
    :storage_engines => {
      :file => Merb::Upload::Storage::File
    }
  }
  
  Merb.push_path(:uploader, Merb.root / "app" / "uploaders", "**/*.rb")
  
  Merb.add_generators File.dirname(__FILE__) / 'generators' / 'uploader_generator'

end