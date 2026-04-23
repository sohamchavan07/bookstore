# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"

# Supabase
pin "@supabase/supabase-js", to: "https://ga.jspm.io/npm:@supabase/supabase-js@2.39.7/dist/module/index.js"
pin "@supabase/postgrest-js", to: "https://ga.jspm.io/npm:@supabase/postgrest-js@1.9.1/dist/module/index.js"
pin "@supabase/functions-js", to: "https://ga.jspm.io/npm:@supabase/functions-js@2.1.5/dist/module/index.js"
pin "@supabase/gotrue-js", to: "https://ga.jspm.io/npm:@supabase/gotrue-js@2.61.0/dist/module/index.js"
pin "@supabase/realtime-js", to: "https://ga.jspm.io/npm:@supabase/realtime-js@2.9.1/dist/module/index.js"
pin "@supabase/storage-js", to: "https://ga.jspm.io/npm:@supabase/storage-js@2.5.5/dist/module/index.js"
