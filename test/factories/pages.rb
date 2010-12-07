Factory.define :page do |f|
  f.association :user
  f.title "Test page"
  f.association :menu
  f.sequence(:url) {|n| "test#{n}" }
end