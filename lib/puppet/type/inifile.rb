# Type that can by used to manage ini based config files.

module Puppet
  newtype(:inifile) do
    @doc = "Uses Puppet's inifile parser to manage ini files"

    ensurable do
      desc "Create or destroy an ini entry."

      newvalue(:present) do
        provider.create
      end

      newvalue(:absent) do
        provider.destroy
      end
    end

    newparam(:name) do
      desc "Name of config file entry"
      isnamevar
    end

    newparam(:section) do
      desc "Section this value resides in"
      isnamevar
    end

    newproperty(:value) do
      desc "Value of config entry."
    end

    newparam(:target) do
      desc "Ini formatted config to manage"
    end

    def self.title_patterns
      identity = lambda {|x| x}
      [[
        /^(.*):(.*)$/,
       [
         [ :name, identity ],
         [ :section, identity ]
       ]
      ]]
    end

    def self.namevar_join(hash)
      "#{hash[:name]}:#{hash[:section]}"
    end

  end
end
