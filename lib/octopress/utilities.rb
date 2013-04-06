require 'time'
require 'tzinfo'

module Octopress
  class Utilities
    def self.time_in_timezone(time, timezone)
      unless timezone.nil? || timezone.empty? || timezone == 'local'
        tz = TZInfo::Timezone.get(timezone) #setup Timezone object
        adjusted_time = tz.utc_to_local(time.utc) #time object without correct offset
        #time object with correct offset
        time = Time.new(
          adjusted_time.year,
          adjusted_time.month,
          adjusted_time.day,
          adjusted_time.hour,
          adjusted_time.min,
          adjusted_time.sec,
          tz.period_for_utc(time.utc).utc_total_offset()
        )
        #convert offset to utc instead of just ±0 if that was specified
        if ['utc','zulu','universal','uct','gmt','gmt0','gmt+0','gmt-0'].include? timezone.downcase
          time = time.utc
        end
      end
      time
    end
  end
end
