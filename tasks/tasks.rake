namespace :db2s3 do
  namespace :backup do
    desc "Save a full back to S3"
    task :full => :environment do
      DB2S3.new.full_backup
    end
  end

  desc "Provide estimated costs for backing up your DB to S3"
  task :metrics => :environment do
    def format_size(size)
      units = %w{B KB MB GB TB}
      e = (Math.log(size)/Math.log(1024)).floor
      s = "%.3f" % (size.to_f / 1024**e)
      s.sub(/\.?0*$/, units[e])
    end

    metrics = DB2S3.new.metrics
    puts <<-EOS
Estimates only, does not take into account metadata overhead 

DB Size:            #{format_size(metrics[:db_size])}
Full backups/month: #{metrics[:full_backups_per_month]}
Storage Cost $US:   #{metrics[:storage_cost]}
Transfer Cost $US:  #{metrics[:transfer_cost]}
Total Cost $US:     #{metrics[:total_cost]}
    EOS
  end
end
