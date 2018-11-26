# Overview

Stock Trader is a web-based application for users to build and review a stock portfolio.

# Basic Features

1. Users may create a new account with `name` , `email` , and `password`. The user’s cash account balance defaults to to $5000.00 USD. A user can only register once with any given email.
2. A user can authenticate via `email` and `password` to access their account.
3. A user may purchase shares of stock at its current price by specifying its ticker symbol and quantity of shares.
A user can only buy whole number quantities of shares.
A user can only buy shares if they have enough cash in their account for a given purchase.
A user can only buy shares if the ticker symbol is valid.
A purchase is denied if the quoted price is no more than 1% more than the quoted price.
4. A user may view a list of all transactions made to date so that
they can perform an audit. Audit logs may be filtered by stock symbol and/or date range. Audit list may be reviewed by purchase price, share ammount, date, or stock symbol. Audit logs may be diplayed in print friendly format. Audit logs may be exported in comma seperated value format.
5. A user I want to view a list of all the stocks they own along with their current values so that they can review investment performance.
Current values are based on the latest price and quantity owned for a
given stock. Users can search or sort the list on multiple metrics. A user is provided with the total current value of their stock portfolio.
6. As a user I am given a dynamic indication of stock performance in the form of font color of stock symbols and current prices in my
portfolio which change dynamically to indicate performance: Red when the current price is less than the day’s open price, grey when the current price is equal to the day’s open price, and green when the current price is greater than the day’s open price.

# Technologies

* Ruby 2.4.5
* Rails 5.2
* PostgreSQL
* Devise
* Faraday/Typhoeus
* Bootstrap
* jQuery
* Effective Datatables

# Install instructions

1. Clone this repo.
2. Ensure that Ruby 2.4.5, PostgreSQL, and a recent version of bundler are installed.
3. Start PostgreSQL.
4. Execute `bundle install` and ensure any additional dependencies are installed.
5. Initialize the database by executing `rails db:create`, `rails db:migrate`, `rails db:seed`.
6. Start the application with `rails s`
7. Visit the application at default address `localhost:3000` and create a new account or login to the default account with credentials username: `test@gmail.com` and password: `password`.

# Roadmap

1. Rigorous automated testing suite
1. Implement a cache to retain portfolio total data for performance purposes.