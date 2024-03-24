require 'securerandom'
FactoryBot.define do

  factory :video do
    title { 'title' }
    description { 'description' }
    video_id { SecureRandom.uuid }
    link { 'https://www.youtube.com/watch?v=o-FojzO70bMa' }
  end
end