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
    strict: false # Fail on warnings? (true/false)
  )
end