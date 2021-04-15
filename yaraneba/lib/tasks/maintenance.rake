# frozen_string_literal: true

namespace :maintenance do
  desc 'メンテナンス実行'
  task :start do
    if File.file?('./app/views/_maintenance.html.erb')
      File.rename('./app/views/_maintenance.html.erb', './app/views/maintenance.html.erb')
    else
      p 'すでに実行中'
    end
  end

  desc 'メンテナンス終了'
  task :end do
    if File.file?('./app/views/maintenance.html.erb')
      File.rename('./app/views/maintenance.html.erb', './app/views/_maintenance.html.erb')
    else
      p 'すでに終了済み'
    end
  end
end
