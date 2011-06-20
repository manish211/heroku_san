Feature: Command Line

  Background:
    Given I run `rails new heroku_san_test -O`
    And I cd to "heroku_san_test"
    And I overwrite "Gemfile" with:
      """
      source :rubygems
      gem 'heroku_san', :path => '../../../.'
      """

  Scenario: Config file can be formatted like Rails' database.yml
    Given a file named "config/heroku.yml" with:
      """
      production: 
        app: awesomeapp
      staging:
        app: awesomeapp-staging
      demo: 
        app: awesomeapp-demo
      """

    When I run `rake --trace heroku:apps:local`

    Then the output should contain "production is shorthand for the Heroku app awesomeapp"
    And  the output should contain "staging is shorthand for the Heroku app awesomeapp-staging"
    And  the output should contain "demo is shorthand for the Heroku app awesomeapp-demo"

  Scenario: Config file still accepts the heroku_san format
    Given a file named "config/heroku.yml" with:
      """
      apps:
        production: awesomeapp
        staging: awesomeapp-staging
        demo: awesomeapp-demo
      """

    When I run `rake --trace heroku:apps:local`

    Then the output should contain "production is shorthand for the Heroku app awesomeapp"
    And  the output should contain "staging is shorthand for the Heroku app awesomeapp-staging"
    And  the output should contain "demo is shorthand for the Heroku app awesomeapp-demo"

  Scenario: Tag information can be listed
    Given a file named "config/heroku.yml" with:
      """
      production:
        app: awesomeapp
        tag: ci/*
      staging:
        app: awesomeapp-staging
        tag: staging/*
      demo:
        app: awesomeapp-demo
      """

    When I run `rake --trace all heroku:apps:local`

    Then the output should contain "the production TAG is 'ci/*'"
    And  the output should contain "the staging TAG is 'staging/*'"

