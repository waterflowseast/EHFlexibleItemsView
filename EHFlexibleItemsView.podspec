Pod::Spec.new do |s|
  s.name             = 'EHFlexibleItemsView'
  s.version          = '1.0.0'
  s.summary          = 'a view which arranges different-width item views line by line.'

  s.description      = <<-DESC
EHFlexibleItemsView: a view which arranges different-width item views line by line.
EHFlexibleItemsSelectionView: selection version of EHFlexibleItemsView, you can single-select or multiple-select
                       DESC

  s.homepage         = 'https://github.com/waterflowseast/EHFlexibleItemsView'
  s.screenshots     = 'https://github.com/waterflowseast/EHFlexibleItemsView/raw/master/screenshots/1.png', 'https://github.com/waterflowseast/EHFlexibleItemsView/raw/master/screenshots/2.png', 'https://github.com/waterflowseast/EHFlexibleItemsView/raw/master/screenshots/3.png', 'https://github.com/waterflowseast/EHFlexibleItemsView/raw/master/screenshots/4.png'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Eric Huang' => 'WaterFlowsEast@gmail.com' }
  s.source           = { :git => 'https://github.com/waterflowseast/EHFlexibleItemsView.git', :tag => s.version.to_s }
  s.ios.deployment_target = '7.0'
  s.source_files = 'EHFlexibleItemsView/Classes/**/*'
  s.dependency 'EHItemViewCommon', '~> 1.0.0'
end
