# github-search-ios

- An iOS app project of using GitHub API which implements:
  - Incremental search.
  - Pure URLSession to fulfill API request.
  - API request throttling.
  - Use NSOperation to handle network image downloading without using third party libraries.

- Githu API used by the project:
  - https://docs.github.com/en/rest/reference/search
  - https://docs.github.com/en/rest/reference/search#search-repositories

- The project is developed in **Xcode 12.5** and **latest Swift 5**, please **use Xcode 12.5** to build and run the project.

## Code coverage result

This project also implement both unit tests and UI tests, and the code coverage for the main app code is **73.0%**.

<img src="https://github.com/hayasilin/github-search-ios/blob/master/resources/code_coverage_70.png">

## iOS Unit Tests code coverage
- If you want to know more about iOS unit tests implementation, you can see my repo of [iOS Unit Tests Guide](https://github.com/hayasilin/unit-tests-ios-guide).
- You can also see my demo project [iOS Unit Tests Demo Project](https://github.com/hayasilin/unit-tests-ios-demo-project).

## iOS UI Tests Guide
- If you want to know more about iOS UI tests implementation, you can see my repo of [iOS & Android UI Automation Tests Guide](https://github.com/hayasilin/ios-android-ui-automation-tests-guide).
