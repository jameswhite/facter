require 'facter/util/ip'

Facter.add(:arp) do
  confine :kernel => :linux
  setcode do
    arp = []
    output = Facter::Util::Resolution.exec('arp -a')
    if not output.nil?
      output.each_line do |s|
        arp.push($1) if s =~ /^\S+\s\S+\s\S+\s(\S+)\s\S+\s\S+\s\S+$/
      end
    end
    arp[0]
  end
end

Facter::Util::IP.get_interfaces.each do |interface|
  Facter.add("arp_" + Facter::Util::IP.alphafy(interface)) do
    confine :kernel => :linux
    setcode do
      Facter::Util::IP.get_arp_value(interface)
    end
  end
end
