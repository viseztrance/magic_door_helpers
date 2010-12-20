#
# = magic_door.rb - MagicDoor generator
#
# Author:: Daniel Mircea daniel@viseztrance.com
# Copyright:: Copyright (c) 2010 Daniel Mircea
# License:: MIT and/or Creative Commons Attribution-ShareAlike

require 'digest/md5'
require 'ostruct'

class MagicDoorHelper

  # Button or link text.
  attr_accessor :text

  # MagicDoor options Hash.
  attr_accessor :md_options

  # Local save file location.
  attr_accessor :destination_path

  # Public save file location.
  attr_reader :public_path

  # Creates a new magic door helper object.
  # ==== Arguments
  # [*text*] The text that will be used on the button.
  # [*options*] The magic door params hash.
  def initialize(text, options = {})
    self.text             = text
    self.md_options       = options
    self.destination_path = options[:destination_path] || MagicDoor.defaults[:destination_path]
    self.public_path      = options[:public_path]
  end

  # Generates the actual button and returns the result public path.
  #
  # Skips button generation if cache exists.
  def generate_and_get_path!
    generate_button unless cache.exists
    File.join(public_path.to_s, cache.file_name)
  end

  # Generates the actual button.
  def generate_button
    m           = MagicDoor.new(md_options)
    m.text      = text
    m.file_name = cache.file_name
    m.save
    Rails.logger.info("Generated MagicDoor button %s." % text.inspect)
  end

  # Sets the public path to the image location.
  #
  # If the argument is nil, nor is a default set, it will attempt to generate one from the destination param.
  def public_path=(path)
    @public_path = path || MagicDoor.defaults[:public_path] || destination_path.gsub(File.join(RAILS_ROOT, 'public'), '')
  end

  # Uses the text and MD options hash to generate an unique token
  # ==== Is a container for the following attributes:
  # [*file_name*] The unique file name. Will always be a png file.
  # [*exists*] Returns true if the +file_name+ exists.
  def cache
    return @cache if @cache
    @cache = OpenStruct.new
    @cache.file_name = Digest::MD5.hexdigest(text + (md_options[:css] || MagicDoor.defaults[:css])) + '.png'
    @cache.exists = File.exist?(File.join(destination_path, @cache.file_name))
    @cache
  end

end
