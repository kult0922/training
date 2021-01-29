# frozen_string_literal: true

module Batch
  class Maintenance
    def self.start
      if File.exist?(Constants::MAINTENANCE)
        puts 'すでにメンテナンスモードです'
      elsif system("touch #{Constants::MAINTENANCE}")
        puts 'メンテナンスモードを開始します'
      else
        puts 'メンテナンスモード開始に失敗しました'
      end
    end

    def self.end
      if system("rm #{Constants::MAINTENANCE}")
        puts 'メンテナンスモードを終了します'
      else
        puts 'メンテナンスモード終了に失敗しました'
      end
    end
  end
end
