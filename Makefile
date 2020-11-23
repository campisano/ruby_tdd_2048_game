.PHONY: run
run:
	bundle exec ruby main.rb

.PHONY: install
install:
	bundle install

.PHONY: test
test:
	bundle exec rspec
