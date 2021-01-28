module Batch
  class Maintenance
    def self.start
      puts "メンテナンスモードを開始します"
      system("touch 'tmp/maintenance'")
    end

    def self.end
      puts "メンテナンスモードを終了します"
      system("rm 'tmp/maintenance'")
    end
  end
end
