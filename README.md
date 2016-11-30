# ticketfy-api

A Customer Support Ticket System API made with [Rails](http://rubyonrails.org/) - and ♥.

[![CircleCI](https://circleci.com/gh/roalcantara/ticketfy-api.svg?style=shield)](https://circleci.com/gh/roalcantara/ticketfy-api)
[![Coverage Status](https://coveralls.io/repos/github/roalcantara/ticketfy-api/badge.svg?branch=master)](https://coveralls.io/github/roalcantara/ticketfy-api?branch=master)
[![license](https://img.shields.io/github/license/mashape/apistatus.svg)]()
[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

## Dependencies

To run this project you need to have:

* Ruby 2.3.1 - You can use [RVM](http://rvm.io)
* [MySQL](https://www.mysql.com/)

## Setup the project

1. Install the dependencies above
2. `$ git clone https://github.com/roalcantara/ticketfy-api.git` - Clone the project
3. `$ cd ticketfy-api` - Go into the project folder
4. `$ bundle exec bin/setup` - Run the setup script

## Running specs and checking coverage

`$ bundle exec rspec spec --format documentation --color` to run the specs.

`$ coverage=on bundle exec rspec spec --format documentation --color` to generate the coverage report then open the file `coverage/index.html` on your browser.

If everything goes OK, you can now run the project!

## Running the project

1. `$ bundle exec rails s` - Opens the server
2. Open [http://localhost:3000](http://localhost:3000)

## How to contribute

1. Follow the [Semantic Versioning Specification](http://semver.org/)
2. Follow the [GitHub Flow](https://guides.github.com/introduction/flow/)
3. Follow the [5 Useful Tips For A Better Commit Message](https://robots.thoughtbot.com/5-useful-tips-for-a-better-commit-message) article and the [How to Write a Git Commit Message](http://chris.beams.io/posts/git-commit/) post
4. Use [Commitizen cli](http://commitizen.github.io/cz-cli/) when committing

## License

Ticketfy is released under the [MIT License](http://www.opensource.org/licenses/MIT).
