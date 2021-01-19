LATEST_WEBPACKER         = "\"@rails\/webpacker\": \"rails\/webpacker#b6c2180\","
WEBPACK_STYLESHEETS_PATH = "#{Webpacker.config.source_path}/stylesheets"
APPLICATION_LAYOUT_PATH  = Rails.root.join("app/views/layouts/application.html.erb")

# Current webpacker version relies on an older version of PostCSS
# which the latest TailwindCSS version is not compatible with
gsub_file("package.json", /\"@rails\/webpacker\".*/) { |matched_line| matched_line = LATEST_WEBPACKER }

say "Adding latest Tailwind CSS and postCSS"
run "yarn add tailwindcss@latest postcss@latest autoprefixer@latest"
insert_into_file "#{Webpacker.config.source_entry_path}/application.js", "\nrequire(\"stylesheets/application.scss\")\n"

say "Adding minimal configuration for Tailwind CSS to work properly"
directory Pathname.new(__dir__).join("stylesheets"), Webpacker.config.source_path.join("stylesheets")

insert_into_file "postcss.config.js", "require('tailwindcss'),\n\t", before: "require('postcss-import')"
