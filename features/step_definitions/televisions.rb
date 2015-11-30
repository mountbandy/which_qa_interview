Given(/^I am a (non member|member) currently on the Which\? television review listings page$/) do |arg|
  visit 'http://www.which.co.uk/reviews/televisions/'
  expect(find('div.masthead-headings').find('h1').text).to eq('Televisions')
end

When(/^I refine results by screen size to (.*)$/) do |screen_size|
  within all('div.cont-filter-options.toggle-panel')[0] do

    choose_screen_size = find('label.inactive', text: screen_size)

    @product = choose_screen_size.text[/\(.*?\)/].delete('()').to_i
    choose_screen_size.click
  end
  sleep_until_ajax_finished
end

Then(/^results returned will only be of televisions (?:between|over) (.*)$/) do |screen_size|
  expect(find(:css, '.product-count').text.to_i).to eq @product

  scroll_to_bottom

  screen_sizes = []

  within '.products' do
    @product.times { |i| screen_sizes.push all(:css, '.product-listing__key-fact')[i].text.to_i }
  end

  case screen_size
    when '17-26"'
      expect(screen_sizes).not_to include(16..0)
      expect(screen_sizes).to include(17..26)
      expect(screen_sizes).not_to include(27..99)
    when '27-39"'
      expect(screen_sizes).not_to include(27..0)
      expect(screen_sizes).to include(27..39)
      expect(screen_sizes).not_to include(40..99)
    when '40-46"'
      expect(screen_sizes).not_to include(39..0)
      expect(screen_sizes).to include(40..46)
      expect(screen_sizes).not_to include(47..99)
    when '47-55"'
      expect(screen_sizes).not_to include(46..0)
      expect(screen_sizes).to include(47..55)
      expect(screen_sizes).not_to include(56..99)
    when '56"+'
      expect(screen_sizes).not_to include(55..0)
      expect(screen_sizes).to include(56..99)
  end
end

When(/^I select (refine|view) button$/) do |button|
  if button == 'refine'
    find('.action-refine').click
    sleep_until_ajax_finished
  else
    find('.apply-filters').click
    sleep_until_ajax_finished
  end
end

And(/^expands list of screen size options$/) do
  page.execute_script 'window.scrollBy(0,400)'
  first('.toggle-show-all').click
end

When(/^I select sort by (.*)$/) do |sort_by|
  select sort_by, from: 'sortby'
end

Then(/^results are ordered by (lowest|highest) to (?:lowest|highest priced) televisions$/) do |price_order|

  sleep_until_ajax_finished

  expect(find('.product-count').text.to_i).to eq @product

  scroll_to_bottom

  tv_prices = []

  within '.products' do
    @product.times { |i| tv_prices.push all(:css, '.price-value')[i].text[/\d.+/].to_f }
  end

  tv_price_list = false
  if price_order == 'lowest'
    tv_prices.count.times { |i| tv_price_list = tv_prices[i] <= tv_prices[i+1] unless tv_prices[i+1].nil? }
  else
    tv_prices.count.times { |i| tv_price_list = tv_prices[i] >= tv_prices[i+1] unless tv_prices[i+1].nil? }
  end
  expect(tv_price_list).to eq(true), 'The results of televisions are not ordered correctly'
end


Then(/^results returned will only be of (.*) televisions$/) do |brand|

  sleep_until_ajax_finished

  units = find('label', text: brand).text[/\d.+/].to_i

  expect(find('.product-count').text.to_i).to eq units

  scroll_to_bottom

  manufacturer = []

  within '.products' do
    units.times { |i| manufacturer.push all(:css, '.product-listing__manufacturer')[i].text }
  end

  expect(manufacturer.count).to eq(units), 'The number of models of the manufacturer is mismatched with results '
  expect(manufacturer.uniq).to eq([brand]), "The brand was expected to be #{brand}, but of got #{manufacturer.uniq} instead"
end

When(/^I refine results by brand to (.*)$/) do |brand|
  find('label.inactive', text: brand).click
end

When(/^I select the first television in results$/) do
  @product_name = first('.product-listing__name--narrow').text
  first('.product-listing__name-and-key-fact').click
end

Then(/^product summary page is displayed for the same television$/) do
  expect(find('div.masthead-headings').find('h1').text).to eq(@product_name)
  expect(page).to have_content('Product summary')
end

When(/^I select the (.*) section$/) do |section|
  click_link(section)
end

Then(/^as a non member I'm asked to subscribe to Which$/) do
  expect(page).to have_selector('#dfp__prod-review__main')
end

def scroll_to_bottom
  page.execute_script 'window.scrollBy(0,10000)' until first(:css, '.footer')
end

def sleep_until_ajax_finished
  Timeout::timeout(3) { sleep 0.1 until page.evaluate_script('jQuery.active').zero? }
end