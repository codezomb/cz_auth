FactoryGirl.define do

  factory :user do
    sequence(:email)      { |n| "test_#{n}@bqsoft.com" }
    password              'p@ssw0rd'
    password_confirmation 'p@ssw0rd'
  end

end