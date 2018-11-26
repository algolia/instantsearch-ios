# More documentation about how to customize your build
# can be found here:
# https://docs.fastlane.tools
fastlane_version "1.109.0"

lane :run_swift_lint do
	swiftlint(
    mode: :lint,      # SwiftLint mode: :lint (default) or :autocorrect
    config_file: "config/.swiftlint.yml",       # Custom configuration file of SwiftLint (optional)
    # output_file: "swiftlint.result.json", # The path of the output file (optional)
    # config_file: ".swiftlint-ci.yml",     # The path of the configuration file (optional)
    strict: false, # Fail on warnings? (true/false)
    executable: "config/swiftlint"
  )
end

lane :check_alpha_beta_dependencies do
  podfilePath = Dir.pwd + "/../Podfile"
  cartfilePath = Dir.pwd + "/../Cartfile"

  

  if ( 
    (File.file?(podfilePath) && File.foreach(podfilePath).grep(/alpha/).any?) ||
    (File.file?(podfilePath) && File.foreach(podfilePath).grep(/beta/).any?) ||
    (File.file?(cartfilePath) && File.foreach(cartfilePath).grep(/beta/).any?) ||
    (File.file?(cartfilePath) && File.foreach(cartfilePath).grep(/alpha/).any?)
  )
    raise "Error: There is an alpha or beta dependency in your Podfile. It is dangerous to deploy a new version of the library with unstable dependencies."
  else
    puts "No Alpha or Beta dependencies found in Podfile, proceeding..."
  end

end