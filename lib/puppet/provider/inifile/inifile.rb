Puppet::Type.type(:inifile).provide(:inifile) do
  desc "Provider that uses Puppet's shiiped inifile parser utility library"

  require 'puppet/util/inifile'

  def self.instances

    iniobj = Puppet::Util::IniConfig::File.new

    iniobj.read('/Users/ody/puppet.conf')

    inst = Array.new
    entry = Hash.new

    iniobj.each_section do |section|
      class << section
        attr_reader :entries
      end
      section.entries.each do |line|
        if line.is_a?(Array)
          entry = {
            :name     => line[0],
            :value    => line[1],
            :target   => '/Users/ody/puppet.conf',
            :section  => section.name,
            :ensure   => :present,
            :provider => self.name
          }
          inst << new(entry)
        end
      end
    end
    debug(inst.inspect)
    inst
  end

  def self.prefetch(entries)
    instances.each do |prov|
      if line = entries[prov.name]
        line.provider = prov
      end
    end
  end

  def properties
    #if @property_hash.empty?
    #  @property_hash = query || {:ensure => :absent}
    #  @property_hash[:ensure] = :absent if @property_hash.empty?
    #end
    @property_hash.dup
  end

  def exists?
    !(@property_hash[:ensure] == :absent or @property_hash.empty?)
  end

  def create
  end

  def destroy
  end

  def value
    @property_hash[:value]
  end

  def section
    @property_hash[:section]
  end

end
