require "redis"
require "roo/csv"
class AdAttribution
  def self.import(file_path: nil)
    redis = Redis.new(host: Rails.application.config.redis_host,port: Rails.application.config.redis_port)
    header = []
    first_val = 0
    puts "starting importing file...."
    ttl = 1296000
    rows_inserted = 0
    file = Roo::Spreadsheet.open(file_path)
    (0..file.last_row).each do |line|
      check_for_header = file.row(line)
      check_for_header.each do |column|
        if column =='_id'
          header = check_for_header
          first_val = line+1
          break
        end
      end
    end
    (first_val..file.last_row).each do |line|
      row = Hash[[header,file.row(line)].transpose]
      key = row["_id"] << "--"<< row["channelid"] << ":#{row["campaignid"]}" << ":#{row["clicktime"]}"
      val = redis.hset(key, row)
      key = nil
      redis.expire(row["_id"],ttl)
      rows_inserted+=1 if val.positive?
    end
    puts "#{rows_inserted} are inserted in REDIS...."
  end
end
