# Which? QA technical test

##The aim of these tests is to test user journeys on the Which? television review listings page.

This is a sample of how I might go about writing user journey tests.

##Running the example

Make sure you have bundler installed:

    gem install bundler

Install gems in the `Gemfile`:

    bundle install

To execute the feature file

    bundle exec cucumber features/televisions.feature

###NOTE: This example runs on Chrome only.

##Conclusion

I have aimed to meet the scope of this assignment only.
To improve the architecture of this test code base: I would refactor when necessary page objects, helpers and factories to get better abstraction and reuse.