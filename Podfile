# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Shopping' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  

  # Pods for Shopping
  #  pod 'Google/SignIn'
  #  pod 'GoogleSignIn'
  
  pod 'Alamofire'
  pod 'SwiftyJSON'
  pod 'IQKeyboardManagerSwift'
  pod 'ImageSlideshow'
  pod 'IQDropDownTextField'
  pod 'SkyFloatingLabelTextField', '~> 3.0'
  pod 'Dodo', '~> 9.0'
  pod 'RappleProgressHUD'
  pod 'Firebase'
  pod 'SDWebImage/WebP'
  pod 'OpalImagePicker', '~> 1.4.0'
  pod 'ImageSlideshow/Kingfisher'
  pod 'AlamofireImage', '~> 3.3'
  pod "WARangeSlider"
  pod 'Firebase/Core'
  pod 'Firebase/Messaging'
  pod 'Google/SignIn'
  pod 'NVActivityIndicatorView'
  pod 'DropDown'

  
  target 'ShoppingTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'ShoppingUITests' do
    inherit! :search_paths
    # Pods for testing
  end
  
  post_install do |installer|
      installer.pods_project.build_configurations.each do |config|
          config.build_settings.delete('CODE_SIGNING_ALLOWED')
          config.build_settings.delete('CODE_SIGNING_REQUIRED')
      end
  end


end
