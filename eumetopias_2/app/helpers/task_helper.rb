module TaskHelper
  def status_select_options
    options =  [['全て', '']]
    TaskStatus.all.each {|status| options.push([status.name, status.id])}
    options
  end
  def label_select_options
    options =  [['全て', '']]
    Label.all.each { |label| options.push([label.name, label.id])}
    options
  end
end
