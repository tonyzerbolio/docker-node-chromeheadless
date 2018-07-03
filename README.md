# docker-node-chromeheadless

Container with node and chrome headless to be able to run Angular 2+ unit tests with GitLab CI.

## gitlab.yml
```
image: humpedli/docker-node-chromeheadless

cache:
  key: "PROJECT"
  paths:
    - node_modules/

stages:
  - setup
  - test

setup:
  stage: setup
  script:
    - npm prune
    - npm install

lint:
  stage: test
  script:
    - node node_modules/@angular/cli/bin/ng lint

test:
  stage: test
  script:
    - node node_modules/@angular/cli/bin/ng test --karma-config karma-ci.conf.js --code-coverage
  coverage: '/^Statements\s*:\s*([^%]+)/'
```
---
## karma-ci.conf.js

```
// Karma configuration file, see link for more information
// https://karma-runner.github.io/1.0/config/configuration-file.html

module.exports = function (config) {
  config.set({
    basePath: '',
    frameworks: ['jasmine', '@angular-devkit/build-angular'],
    plugins: [
      require('karma-jasmine'),
      require('karma-chrome-launcher'),
      require('karma-jasmine-html-reporter'),
      require('karma-coverage-istanbul-reporter'),
      require('@angular-devkit/build-angular/plugins/karma')
    ],
    client: {
      clearContext: false // leave Jasmine Spec Runner output visible in browser
    },
    coverageIstanbulReporter: {
      dir: require('path').join(__dirname, 'coverage'),
      reports: ['html', 'lcovonly', 'text-summary'],
      fixWebpackSourcePaths: true,
      thresholds: {
        emitWarning: false, // set to `true` to not fail the test command when thresholds are not met
        global: { // thresholds for all files
          statements: 90,
          lines: 90,
          branches: 90,
          functions: 90
        }
      }
    },
    angularCli: {
      environment: 'dev'
    },
    reporters: ['progress', 'kjhtml'],
    port: 9876,
    colors: true,
    logLevel: config.LOG_INFO,
    autoWatch: false,
    browsers: ['ChromeHeadlessCI'],
    singleRun: true,
    customLaunchers: {
      ChromeHeadlessCI: {
        base: 'ChromeHeadless',
        flags: [
          '--no-sandbox',
          '--headless',
          '--disable-gpu'
        ]
      }
    }
  });
};
```
