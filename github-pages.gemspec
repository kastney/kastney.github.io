# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name     = "github-pages"
  spec.version  = "1.0.0"
  spec.authors  = ["kastney"]
  spec.email    = ["kastney@gmail.com"]

  spec.summary  = "This repository contains the code for my personal website, made with Jekyll. I chose Jekyll for its ease of use and flexibility. The theme was inspired by 'jekyll-theme-yat' and customized to meet my needs. I am proud of the result and sharing this repository with the open-source comunity."
  spec.homepage = "https://github.com/kastney/kastney.github.io"
  spec.license  = "MIT"

  spec.metadata["plugin_type"] = "theme"

  spec.files    = `git ls-files -z`.split("\x0").select do |f|
    f.match(%r!^(LICENSE|README)!i)
  end

  spec.add_development_dependency "bundler", ">= 1.6", "< 3.0"
  spec.add_development_dependency "rake", ">= 12.0", "< 13.0"

  spec.add_runtime_dependency "jekyll", "> 3.5", "< 5.0"
  spec.add_runtime_dependency "jekyll-timeago", "~> 0.13.1"
  spec.add_runtime_dependency 'wdm', '>= 0.1.0'
end
