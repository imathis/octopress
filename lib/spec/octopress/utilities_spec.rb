require "spec_helper"

describe Octopress::Utilities do
  describe '#time_in_timezone' do
    subject do
      Octopress::Utilities
    end

    context "when provided valid parameters in any timezone" do
      before do
        @old_tz = ENV['TZ']
      end

      after do
        ENV['TZ'] = @old_tz
      end

      # The following list of timezones was divined using this approach:
      #
      #   distinct_zones = {}
      #   TZInfo::Timezone.all.each do |tz|
      #     ENV['TZ'] = tz.identifier
      #     key =  Time.local(2013,1,1,0,0,0).to_s
      #     distinct_zones[key] = tz.identifier unless(distinct_zones.has_key?(key))
      #   end
      #   distinct_zones.keys.sort.each do |key|
      #     puts "#{key} => #{distinct_zones[key]}"
      #   end
      #
      # I replaced Africa/Abidjan with UTC because it appears to be the same...
      TIMEZONES=%w(
        UTC
        Africa/Algiers
        Africa/Blantyre
        Africa/Addis_Ababa
        Asia/Riyadh87
        Asia/Tehran
        Asia/Baku
        Asia/Kabul
        Antarctica/Mawson
        Asia/Calcutta
        Asia/Kathmandu
        Antarctica/Vostok
        Asia/Rangoon
        Antarctica/Davis
        Antarctica/Casey
        Australia/Eucla
        Asia/Dili
        Australia/Darwin
        Antarctica/DumontDUrville
        Australia/Adelaide
        Antarctica/Macquarie
        Pacific/Norfolk
        Asia/Anadyr
        Antarctica/McMurdo
        NZ-CHAT
        Etc/GMT-14
        America/Scoresbysund
        America/Araguaina
        America/Argentina/Buenos_Aires
        America/St_Johns
        America/Anguilla
        America/Caracas
        America/Atikokan
        America/Bahia_Banderas
        America/Boise
        America/Dawson
        America/Anchorage
        Pacific/Marquesas
        America/Adak
        Etc/GMT+11
        Etc/GMT+12
      )

      it "correctly converts from any timezone, to any timezone" do
        TIMEZONES.each do |base_tzname|
          base_tz = TZInfo::Timezone.get(base_tzname)
          base_tz.should_not be_nil
          ENV['TZ'] = base_tzname
          baseline = Time.local(2013, 1, 1, 0, 0, 0)
          TIMEZONES.each do |local_tzname|
            local_tz = TZInfo::Timezone.get(local_tzname)
            local_tz.should_not be_nil
            ENV['TZ'] = local_tzname
            local = Time.local(2013, 1, 1, 0, 0, 0)
            offset_seconds = (baseline - local).to_i
            expected_result = baseline - offset_seconds
            subject.time_in_timezone(local, base_tzname).should eq(baseline - offset_seconds)
          end
        end
      end
    end
  end
end
