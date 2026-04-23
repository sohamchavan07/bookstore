# frozen_string_literal: true

module Supabase
  def self.url
    ENV.fetch('SUPABASE_URL', 'YOUR_SUPABASE_URL')
  end

  def self.anon_key
    ENV.fetch('SUPABASE_ANON_KEY', 'YOUR_SUPABASE_ANON_KEY')
  end

  def self.jwt_secret
    ENV.fetch('SUPABASE_JWT_SECRET', 'YOUR_SUPABASE_JWT_SECRET')
  end
end
