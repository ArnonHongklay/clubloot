FactoryGirl.define do
  factory :api_key do
    access_token "MyString"
    expires_at "2017-04-04 20:21:54"
    user_id 1
    active false
  end
end
